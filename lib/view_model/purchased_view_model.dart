import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class PurchasedViewModel extends GetxController {
  //firebase realtime
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  final RxList<Map<String, dynamic>> coupons = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> ordersList = <Map<String, dynamic>>[].obs;
  final RxList<int> selectedItems = <int>[].obs; // Danh sách index của các sản phẩm được chọn
  final RxList<Map<String, dynamic>> stores = <Map<String, dynamic>>[].obs;


  final RxString userId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeUserId();
    _listenToOrders();
  }

  void _initializeUserId() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      userId.value = currentUser.uid;
    }
  }

  void _listenToOrders() {
    if (userId.isEmpty) return;

    _databaseReference.child('users/${userId.value}/PurchasedCart').onValue.listen((event) {
      if (event.snapshot.exists && event.snapshot.value is List) {
        final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
          (event.snapshot.value as List).map(
                (item) => Map<String, dynamic>.from(item as Map),
          ),
        );
        ordersList.value = data;
      } else {
        ordersList.clear();
      }
    });
  }

  void selectItem(int index) {
    selectedItems.add(index); // Thêm sản phẩm vào danh sách đã chọn
  }

  void deselectItem(int index) {
    selectedItems.remove(index); // Loại sản phẩm khỏi danh sách đã chọn
  }

  void toggleItemSelection(int index) {
    if (selectedItems.contains(index)) {
      deselectItem(index);
    } else {
      selectItem(index);
    }
  }

  void increaseQuantity(int index) {
    ordersList[index]['Quantity'] = (ordersList[index]['Quantity'] ?? 1) + 1;
    ordersList.refresh();
  }

  void decreaseQuantity(int index) {
    if (ordersList[index]['Quantity'] > 1) {
      ordersList[index]['Quantity'] -= 1;
      ordersList.refresh();
    }
  }

  List<Map<String, dynamic>> checkoutSelectedItems() {
    // Lấy danh sách sản phẩm được chọn
    final selectedProducts = selectedItems.map((index) {
      final product = Map<String, dynamic>.from(ordersList[index]); // Tạo bản sao của sản phẩm
      product['Quantity'] = ordersList[index]['Quantity'] ?? 1; // Thêm trường Quantity
      return product; // Trả về sản phẩm đã được thêm trường
    }).toList();

    // Trả về danh sách các sản phẩm đã được chọn
    return selectedProducts;
  }

  double calculateTotal(List<Map<String, dynamic>> product) {
    double total = 0.0;
    for (var item in product) {
      total += item['Price']*item['Quantity']; // Cộng dồn giá của mỗi sản phẩm
    }
    return total;
  }


}
