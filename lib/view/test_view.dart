// ignore_for_file: unused_field, prefer_final_fields, avoid_print, use_build_context_synchronously, unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';
import 'package:flutter_hungry_hub/view_model/get_data_viewmodel.dart';
import 'package:get/get.dart';

class TestView extends StatefulWidget {
  const TestView({super.key});

  @override
  State<TestView> createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  final controller = Get.put(GetDataViewModel());
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _stores = [];
  String? _selectedProductId;
  String? _selectedStoreId;
  bool _isLoadingProducts = true;
  bool _isLoadingStores = false;
  bool _isPlacingOrder = false;

  // Giỏ hàng
  List<CartItem> _cart = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _loadStores();
  }

  Future<void> _loadProducts() async {
    await controller.fetchProducts();
    setState(() {
      _products = controller.products;
      _isLoadingProducts = false;
    });
  }

  // Future<void> _loadStores(String productId) async {
  //   setState(() {
  //     _isLoadingStores = true;
  //     _selectedProductId = productId;
  //     _stores.clear();
  //   });
  //   await controller.fetchStoresByProduct(productId);
  //   setState(() {
  //     _stores = controller.stores;
  //     _isLoadingStores = false;
  //   });
  // }

  // Hàm tải cửa hàng
  Future<void> _loadStores() async {
    setState(() {
      _isLoadingStores = true; // Đang tải dữ liệu
      _stores.clear(); // Xóa danh sách cửa hàng hiện tại
    });

    try {
      await controller.fetchStores(); // Gọi hàm fetchStores từ controller
      setState(() {
        _stores = controller.stores; // Cập nhật danh sách cửa hàng
        _isLoadingStores = false; // Dữ liệu đã được tải xong
      });
    } catch (e) {
      print("Error loading stores: $e");
      setState(() {
        _isLoadingStores = false; // Nếu có lỗi, cập nhật lại trạng thái loading
      });
    }
  }

  // Thêm món vào giỏ hàng
  void _addToCart(Map<String, dynamic> product) {
    final existingItemIndex =
        _cart.indexWhere((item) => item.productId == product['id']);

    if (existingItemIndex != -1) {
      // Nếu món đã có trong giỏ hàng, chỉ cần cập nhật số lượng
      setState(() {
        _cart[existingItemIndex].quantity++;
      });
    } else {
      // Nếu món chưa có trong giỏ hàng, thêm món mới vào giỏ
      setState(() {
        _cart.add(CartItem(
          productId: product['id'],
          productName: product['Name'],
          productImageUrl: product['ImageUrl'],
          productPrice: product['Price'],
        ));
      });
    }
    print('cac mon co trong gio hang $product');
  }

  // Tính tổng tiền
  int getTotalPrice() {
    return _cart.fold(0, (sum, item) => sum + item.totalPrice);
  }

  // Xử lý thanh toán
  Future<void> _placeOrder() async {
    if (_selectedStoreId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn cửa hàng!')),
      );
      return;
    }

    if (_cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Giỏ hàng của bạn không có sản phẩm!')),
      );
      return;
    }

    setState(() {
      _isPlacingOrder = true;
    });

    // Giả sử bạn muốn thêm các sản phẩm vào đơn hàng.
    String userId = 'userIdExample'; // Cần thay bằng ID người dùng thực tế
    List<String> productIds = _cart.map((item) => item.productId).toList();
    List<int> quantities = _cart.map((item) => item.quantity).toList();

    try {
      // Thêm đơn hàng vào Firestore
      await controller.addOrder(
        _selectedStoreId!, // ID cửa hàng đã chọn
        userId, // ID người dùng
        productIds, // Danh sách ID sản phẩm
        quantities, // Danh sách số lượng sản phẩm
      );

      // Nếu đơn hàng được đặt thành công
      setState(() {
        _isPlacingOrder = false;
        _cart.clear(); // Xóa giỏ hàng sau khi đặt hàng thành công
      });

      Navigator.pop(context); // Đóng dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Đơn hàng của bạn đã được đặt thành công!')),
      );
    } catch (error) {
      setState(() {
        _isPlacingOrder = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Có lỗi xảy ra khi đặt hàng, vui lòng thử lại!')),
      );
    }
  }
  // Xử lý thanh toán
  // Future<void> _placeOrder() async {
  //   if (_selectedStoreId == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Vui lòng chọn cửa hàng!')),
  //     );
  //     return;
  //   }
  //
  //   if (_cart.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Giỏ hàng của bạn không có sản phẩm!')),
  //     );
  //     return;
  //   }
  //
  //   setState(() {
  //     _isPlacingOrder = true;
  //   });
  //
  //   String userId = 'userIdExample'; // Cần thay bằng ID người dùng thực tế
  //
  //   // Gộp productIds và quantities thành ListProductOrders
  //   List<Map<String, dynamic>> listProductOrders = _cart.map((item) {
  //     return {
  //       'productId': item.productId,
  //       'quantity': item.quantity,
  //     };
  //   }).toList();
  //
  //   try {
  //     // Thêm đơn hàng vào Firestore
  //     await controller.addOrder(
  //       _selectedStoreId!, // ID cửa hàng đã chọn
  //       userId, // ID người dùng
  //       listProductOrders, // Danh sách sản phẩm và số lượng
  //     );
  //
  //     // Nếu đơn hàng được đặt thành công
  //     setState(() {
  //       _isPlacingOrder = false;
  //       _cart.clear(); // Xóa giỏ hàng sau khi đặt hàng thành công
  //     });
  //
  //     Navigator.pop(context); // Đóng dialog
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Đơn hàng của bạn đã được đặt thành công!')),
  //     );
  //   } catch (error) {
  //     setState(() {
  //       _isPlacingOrder = false;
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //           content: Text('Có lỗi xảy ra khi đặt hàng, vui lòng thử lại!')),
  //     );
  //   }
  // }

  // Hiển thị giỏ hàng
  void _showCartDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateDialog) {
            return AlertDialog(
              title: const Text('Giỏ hàng'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    // Hiển thị các sản phẩm trong giỏ hàng
                    if (_cart.isNotEmpty)
                      ..._cart.map((item) {
                        return ListTile(
                          leading: Image.network(
                            item.productImageUrl ?? '',
                            width: 50,
                            height: 50,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image_not_supported);
                            },
                          ),
                          title: Text(
                            item.productName ?? 'Không xác định',
                            style: const TextStyle(fontSize: 16),
                          ),
                          subtitle: Text(
                            'Giá: ${item.productPrice?.toString() ?? '0'} VND',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  setStateDialog(() {
                                    if (item.quantity > 1) {
                                      item.quantity--;
                                    } else {
                                      _cart.remove(item);
                                    }
                                  });
                                  setState(
                                      () {}); // Cập nhật state màn hình chính
                                },
                              ),
                              Text('${item.quantity}'),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  setStateDialog(() {
                                    item.quantity++;
                                  });
                                  setState(
                                      () {}); // Cập nhật state màn hình chính
                                },
                              ),
                            ],
                          ),
                        );
                      }).toList()
                    else
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Giỏ hàng trống!',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),

                    // Chọn cửa hàng
                    if (_stores.isNotEmpty)
                      DropdownButton<String>(
                        value: _selectedStoreId,
                        hint: const Text('Chọn cửa hàng'),
                        isExpanded: true,
                        items: _stores.map((store) {
                          return DropdownMenuItem<String>(
                            value: store['id'],
                            child: Text(store['name']),
                          );
                        }).toList(),
                        onChanged: (storeId) {
                          setStateDialog(() {
                            _selectedStoreId = storeId;
                          });
                        },
                      ),

                    // Nếu không có cửa hàng để chọn
                    if (_stores.isEmpty && !_isLoadingStores)
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Không có cửa hàng nào, vui lòng thử lại!'),
                      ),

                    // Hiển thị tổng tiền thanh toán
                    if (_cart.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Tổng tiền: ${getTotalPrice()} VND',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Đóng dialog
                  },
                  child: const Text('Đóng'),
                ),
                ElevatedButton(
                  onPressed: _isPlacingOrder
                      ? null
                      : () async {
                          await _placeOrder();
                          setStateDialog(() {}); // Cập nhật state của dialog
                          setState(() {}); // Cập nhật state của toàn màn hình
                        },
                  child: _isPlacingOrder
                      ? const CircularProgressIndicator()
                      : const Text('Thanh toán'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách sản phẩm'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Hiển thị giỏ hàng khi nhấn vào biểu tượng giỏ hàng
              _showCartDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoadingProducts
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      final product = _products[index];

                      return ListTile(
                        leading: Image.network(
                          product['ImageUrl'] ?? '',
                          width: 50,
                          height: 50,
                        ),
                        title: Text(product['Name']),
                        subtitle: Text('Giá: ${product['Price']} VND'),
                        trailing: IconButton(
                          icon: const Icon(Icons.add_shopping_cart),
                          onPressed: () {
                            _addToCart(product);
                            print('da them vao produc: $product');
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class CartItem {
  final String productId;
  final String productName;
  final String productImageUrl;
  final int productPrice;
  int quantity;

  CartItem({
    required this.productId,
    required this.productName,
    required this.productImageUrl,
    required this.productPrice,
    this.quantity = 1,
  });

  // Tính toán tổng tiền của món hàng
  int get totalPrice => productPrice * quantity;
}
