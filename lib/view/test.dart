// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'orders_view_model.dart';
//
// class OrdersScreen extends StatelessWidget {
//   final OrdersViewModel ordersViewModel = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Shopping Cart"),
//       ),
//       body: Obx(() {
//         if (ordersViewModel.ordersList.isEmpty) {
//           return const Center(child: Text("Your Shopping Cart is empty."));
//         }
//
//         return ListView.builder(
//           itemCount: ordersViewModel.ordersList.length,
//           itemBuilder: (context, index) {
//             final item = ordersViewModel.ordersList[index];
//             return ListTile(
//               leading: Image.network(
//                 item['ImageUrl'], // Hiển thị hình ảnh sản phẩm
//                 fit: BoxFit.cover,
//                 width: 50,
//                 height: 50,
//               ),
//               title: Text(item['Name']),
//               subtitle: Text('${item['Price']} VNĐ'),
//             );
//           },
//         );
//       }),
//     );
//   }
// }
