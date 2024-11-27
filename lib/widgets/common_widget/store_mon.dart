// import 'package:flutter/material.dart';
// import 'package:flutter_hungry_hub/view_model/test_view_model.dart';
// import 'package:get/get.dart';

// class TestView extends StatefulWidget {
//   const TestView({super.key});

//   @override
//   State<TestView> createState() => _TestViewState();
// }

// class _TestViewState extends State<TestView> {
//   final controller = Get.put(TestViewModel());
//   List<Map<String, dynamic>> _products = [];
//   List<Map<String, dynamic>> _stores = []; // Cửa hàng có sản phẩm
//   String? _selectedProductId;
//   String? _selectedStoreId;
//   bool _isLoadingProducts = true;
//   bool _isLoadingStores = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadProducts();
//   }

//   Future<void> _loadProducts() async {
//     await controller.fetchProducts();
//     setState(() {
//       _products = controller.products;
//       _isLoadingProducts = false;
//     });
//   }

//   Future<void> _loadStores(String productId) async {
//     setState(() {
//       _isLoadingStores = true;
//       _selectedProductId = productId;
//       _stores.clear();
//     });
//     await controller.fetchStoresByProduct(productId);
//     setState(() {
//       _stores = controller.stores;
//       _isLoadingStores = false;
//     });
//   }

//   Future<void> _placeOrder() async {
//     if (_selectedStoreId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Vui lòng chọn cửa hàng!')),
//       );
//       return;
//     }

//     // Đặt hàng logic
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Đơn hàng của bạn đã được đặt thành công!')),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Danh sách sản phẩm'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: _isLoadingProducts
//                 ? Center(child: CircularProgressIndicator())
//                 : ListView.builder(
//                     itemCount: _products.length,
//                     itemBuilder: (context, index) {
//                       final product = _products[index];

//                       return ListTile(
//                         leading: Image.network(
//                           product['imageUrl'],
//                           width: 50,
//                           height: 50,
//                         ),
//                         title: Text(product['name']),
//                         subtitle: Text('Giá: ${product['price']} VND'),
//                         trailing: IconButton(
//                           icon: Icon(Icons.store),
//                           onPressed: () => _loadStores(product['id']),
//                         ),
//                       );
//                     },
//                   ),
//           ),
//           if (_selectedProductId != null)
//             _isLoadingStores
//                 ? Center(child: CircularProgressIndicator())
//                 : Column(
//                     children: [
//                       Text('Chọn cửa hàng cho sản phẩm'),
//                       DropdownButton<String>(
//                         value: _selectedStoreId,
//                         hint: Text('Chọn cửa hàng'),
//                         isExpanded: true,
//                         items: _stores.map((store) {
//                           return DropdownMenuItem<String>(
//                             value: store['id'],
//                             child: Text(store['name']),
//                           );
//                         }).toList(),
//                         onChanged: (storeId) {
//                           setState(() {
//                             _selectedStoreId = storeId;
//                           });
//                         },
//                       ),
//                       ElevatedButton(
//                         onPressed: _placeOrder,
//                         child: Text('Đặt hàng'),
//                       ),
//                     ],
//                   ),
//         ],
//       ),
//     );
//   }
// }
