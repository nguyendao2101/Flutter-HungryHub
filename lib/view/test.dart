// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../view_model/orders_view_model.dart';
//
// class LocationScreen extends StatefulWidget {
//   @override
//   _LocationScreenState createState() => _LocationScreenState();
// }
//
// class _LocationScreenState extends State<LocationScreen> {
//   final OrdersViewModel ordersViewModel = Get.put(OrdersViewModel());
//
//   String? selectedLocation; // Địa chỉ được chọn
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chọn địa chỉ'),
//       ),
//       body: FutureBuilder<Map<String, String>>(
//         future: ordersViewModel.fetchLocationsFromFirebase(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text('Lỗi khi tải dữ liệu: ${snapshot.error}'),
//             );
//           } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
//             final Map<String, String> locations = snapshot.data!;
//
//             // Tạo danh sách DropdownMenuItem từ dữ liệu
//             final dropdownItems = locations.entries
//                 .map((entry) => DropdownMenuItem<String>(
//               value: entry.key, // ID địa chỉ làm giá trị
//               child: Text(entry.value), // Tên địa chỉ hiển thị
//             ))
//                 .toList();
//
//             return Center(
//               child: DropdownButton<String>(
//                 value: selectedLocation,
//                 hint: Text('Chọn địa chỉ'),
//                 items: dropdownItems,
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     selectedLocation = newValue;
//                   });
//
//                   // In ra giá trị được chọn
//                   print('Địa chỉ được chọn: $newValue');
//                 },
//                 isExpanded: true, // Đảm bảo nút dropdown chiếm toàn bộ chiều ngang
//               ),
//             );
//           } else {
//             return Center(child: Text('Không có địa chỉ nào.'));
//           }
//         },
//       ),
//     );
//   }
// }
