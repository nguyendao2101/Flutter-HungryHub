// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomeViewModel extends GetxController {
  late TextEditingController searchController = TextEditingController();
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final List<Map<String, dynamic>> shoppingCart = [];
  final RxList<Map<String, dynamic>> favoriteProducts = <Map<String, dynamic>>[].obs;
  final formKey = GlobalKey<FormState>();
  final _userData = {}.obs;
  String _userId = '';
  late stt.SpeechToText _speech;
  bool isListening = false;
  RxMap get userData => _userData;


  @override
  void onInit() {
    super.onInit();
    _initializeUserId();
    initializeSpeechToText();
  }

  void _initializeUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.uid;
      await _getUserData();
    }
  }

  void toggleFavorite(Map<String, dynamic> product) {
    if (isFavorite(product)) {
      favoriteProducts.remove(product);
    } else {
      favoriteProducts.add(product);
      addToFavoriteCart(product);
    }
  }

  bool isFavorite(Map<String, dynamic> product) {
    return favoriteProducts.contains(product);
  }

  Future<void> addAllToPurchasedCart(List<Map<String, dynamic>> products) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        throw Exception("No user is signed in.");
      }

      String userId = currentUser.uid;

      // Lấy danh sách hiện tại từ Firebase
      final snapshot = await _database.child('users/$userId/PurchasedCart').get();
      List<dynamic> currentCart = [];

      if (snapshot.exists && snapshot.value is List) {
        currentCart = List<dynamic>.from(snapshot.value as List);
      }

      // Thêm tất cả sản phẩm mới vào danh sách hiện tại
      for (var product in products) {
        // Kiểm tra trùng lặp dựa trên `id`
        bool isProductInCart = currentCart.any((item) => item['id'] == product['id']);
        if (!isProductInCart) {
          currentCart.add(product);
        }
      }

      // Ghi danh sách cập nhật lên Firebase
      await _database.child('users/$userId/PurchasedCart').set(currentCart);

      // Cập nhật UI
      shoppingCart.clear();
      shoppingCart.addAll(currentCart.cast<Map<String, dynamic>>());
      update();

      // Get.snackbar(
      //   "Success",
      //   "Products added to PurchasedCart!",
      //   snackPosition: SnackPosition.TOP,
      // );
    } catch (e) {
      print('Lỗi khi thêm danh sách sản phẩm: $e');
      // Get.snackbar(
      //   "Error",
      //   "Failed to add products to PurchasedCart!",
      //   snackPosition: SnackPosition.TOP,
      // );
    }
  }
  // xoa san pham da mua
  Future<void> removeAllFromPurchasedCart(List<Map<String, dynamic>> products) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        throw Exception("No user is signed in.");
      }

      String userId = currentUser.uid;

      // Lấy danh sách hiện tại từ Firebase
      final snapshot = await _database.child('users/$userId/ShoppingCart').get();
      List<dynamic> currentCart = [];

      if (snapshot.exists && snapshot.value is List) {
        currentCart = List<dynamic>.from(snapshot.value as List);
      }

      // Chuyển đổi các sản phẩm trong currentCart sang Map<String, dynamic> nếu cần thiết
      List<Map<String, dynamic>> castedCart = currentCart.map((item) {
        return Map<String, dynamic>.from(item as Map);
      }).toList();

      // Xóa từng sản phẩm khỏi danh sách dựa trên `id`
      for (var product in products) {
        castedCart.removeWhere((item) => item['id'] == product['id']);
      }

      // Ghi danh sách cập nhật lên Firebase
      await _database.child('users/$userId/ShoppingCart').set(castedCart);

      // Cập nhật UI
      shoppingCart.clear();
      shoppingCart.addAll(castedCart);
      update();

      // Get.snackbar(
      //   "Success",
      //   "Products removed from PurchasedCart!",
      //   snackPosition: SnackPosition.TOP,
      // );
    } catch (e) {
      print('Lỗi khi xóa danh sách sản phẩm: $e');
      // Get.snackbar(
      //   "Error",
      //   "Failed to remove products from PurchasedCart!",
      //   snackPosition: SnackPosition.TOP,
      // );
    }
  }




  Future<void> addToFavoriteCart(Map<String, dynamic> product) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        throw Exception("No user is signed in.");
      }

      String userId = currentUser.uid;

      // Lấy danh sách ShoppingCart hiện tại từ Firebase
      final snapshot = await _database.child('users/$userId/FavoriteCart').get();
      List<dynamic> currentCart = [];

      if (snapshot.exists && snapshot.value is List) {
        currentCart = List<dynamic>.from(snapshot.value as List);
      }

      // Kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
      bool isProductInCart = currentCart.any((item) => item['id'] == product['id']); // Kiểm tra dựa trên 'id' của sản phẩm

      if (isProductInCart) {
        Get.snackbar(
          "Info",
          "This product is already in your favorite cart.",
          snackPosition: SnackPosition.TOP,
        );
      } else {
        // Thêm sản phẩm mới vào danh sách
        currentCart.add(product);

        // Ghi danh sách cập nhật lên Firebase
        await _database.child('users/$userId/FavoriteCart').set(currentCart);

        // Cập nhật lại shoppingCart và thông báo thành công
        shoppingCart.clear();
        shoppingCart.addAll(currentCart.cast<Map<String, dynamic>>()); // Cập nhật shoppingCart bằng cách cast lại dữ liệu
        update(); // Cập nhật UI

        Get.snackbar(
          "Success",
          "Product added to FavoriteCart!",
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Success",
        "Product added to FavoriteCart!",
        snackPosition: SnackPosition.TOP,
      );
    }
  }
  // xoa khoi danh sach yeu thich
  Future<void> removeFromoFavoriteCart(Map<String, dynamic> product) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        throw Exception("No user is signed in.");
      }

      String userId = currentUser.uid;

      // Lấy danh sách ShoppingCart hiện tại từ Firebase
      final snapshot = await _database.child('users/$userId/FavoriteCart').get();
      List<dynamic> currentCart = [];

      if (snapshot.exists && snapshot.value is List) {
        currentCart = List<dynamic>.from(snapshot.value as List);
      }

      // Kiểm tra xem sản phẩm có trong giỏ hàng không
      bool isProductInCart = currentCart.any((item) => item['id'] == product['id']); // Kiểm tra dựa trên 'id' của sản phẩm

      if (isProductInCart) {
        // Xóa sản phẩm khỏi danh sách giỏ hàng
        currentCart.removeWhere((item) => item['id'] == product['id']);

        // Ghi danh sách cập nhật lên Firebase
        await _database.child('users/$userId/FavoriteCart').set(currentCart);

        // Cập nhật lại shoppingCart và thông báo thành công
        shoppingCart.clear();
        shoppingCart.addAll(currentCart.cast<Map<String, dynamic>>()); // Cập nhật shoppingCart bằng cách cast lại dữ liệu
        update(); // Cập nhật UI

        Get.snackbar(
          "Success",
          "Product removed from FavoriteCart!",
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          "Success",
          "Product removed from FavoriteCart!",
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Success",
        "Product removed from FavoriteCart!",
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // them
  Future<void> addToShoppingCart(Map<String, dynamic> product) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        throw Exception("No user is signed in.");
      }

      String userId = currentUser.uid;

      // Lấy danh sách ShoppingCart hiện tại từ Firebase
      final snapshot = await _database.child('users/$userId/ShoppingCart').get();
      List<dynamic> currentCart = [];

      if (snapshot.exists && snapshot.value is List) {
        currentCart = List<dynamic>.from(snapshot.value as List);
      }

      // Kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
      bool isProductInCart = currentCart.any((item) => item['id'] == product['id']); // Kiểm tra dựa trên 'id' của sản phẩm

      if (isProductInCart) {
        Get.snackbar(
          "Info",
          "This product is already in your shopping cart.",
          snackPosition: SnackPosition.TOP,
        );
      } else {
        // Thêm sản phẩm mới vào danh sách
        currentCart.add(product);

        // Ghi danh sách cập nhật lên Firebase
        await _database.child('users/$userId/ShoppingCart').set(currentCart);

        // Cập nhật lại shoppingCart và thông báo thành công
        shoppingCart.clear();
        shoppingCart.addAll(currentCart.cast<Map<String, dynamic>>()); // Cập nhật shoppingCart bằng cách cast lại dữ liệu
        update(); // Cập nhật UI

        Get.snackbar(
          "Success",
          "Product added to ShoppingCart!",
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Success",
        "Product added to ShoppingCart!",
        snackPosition: SnackPosition.TOP,
      );
    }
  }
  //xoa
  Future<void> removeFromShoppingCart(Map<String, dynamic> product) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        throw Exception("No user is signed in.");
      }

      String userId = currentUser.uid;

      // Lấy danh sách ShoppingCart hiện tại từ Firebase
      final snapshot = await _database.child('users/$userId/ShoppingCart').get();
      List<dynamic> currentCart = [];

      if (snapshot.exists && snapshot.value is List) {
        currentCart = List<dynamic>.from(snapshot.value as List);
      }

      // Kiểm tra xem sản phẩm có trong giỏ hàng không
      bool isProductInCart = currentCart.any((item) => item['id'] == product['id']); // Kiểm tra dựa trên 'id' của sản phẩm

      if (isProductInCart) {
        // Xóa sản phẩm khỏi danh sách giỏ hàng
        currentCart.removeWhere((item) => item['id'] == product['id']);

        // Ghi danh sách cập nhật lên Firebase
        await _database.child('users/$userId/ShoppingCart').set(currentCart);

        // Cập nhật lại shoppingCart và thông báo thành công
        shoppingCart.clear();
        shoppingCart.addAll(currentCart.cast<Map<String, dynamic>>()); // Cập nhật shoppingCart bằng cách cast lại dữ liệu
        update(); // Cập nhật UI

        Get.snackbar(
          "Success",
          "Product removed from ShoppingCart!",
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          "Success",
          "Product removed from ShoppingCart!",
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Success",
        "Product removed from ShoppingCart!",
        snackPosition: SnackPosition.TOP,
      );
    }
  }




  Future<void> _getUserData() async {
    DatabaseReference userRef = _database.child('users/$_userId');
    DataSnapshot snapshot = await userRef.get();

    if (snapshot.exists) {
      _userData.value = Map<String, dynamic>.from(snapshot.value as Map);
    } else {
      _userData.value = {};
    }
  }

  void initializeSpeechToText() async {
    _speech = stt.SpeechToText();
    bool available = await _speech.initialize();
    if (!available) {
      print('Speech recognition not available');
    }
  }

  void toggleListening() async {
    if (!isListening) {
      isListening = true;
      await _speech.listen(onResult: (result) {
        searchController.text = result.recognizedWords;
      });
    } else {
      isListening = false;
      await _speech.stop();
    }
    update();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
