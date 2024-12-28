import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../view_model/elvaluate_product_view_model.dart';
import '../../../view_model/orders_view_model.dart';
import '../../../view_model/profile_view_model.dart';
import 'app_bar_profile.dart';

class EvaluateProduct extends StatefulWidget {
  final Map<String, dynamic> product;
  const EvaluateProduct({super.key, required this.product});

  @override
  State<EvaluateProduct> createState() => _EvaluateProductState();
}

class _EvaluateProductState extends State<EvaluateProduct> {
  final controller = Get.put(ElvaluateProductViewModel());
  final controllerId = Get.put(OrdersViewModel());
  final controllerPro = Get.put(ProfileViewModel());

  final TextEditingController _commentController = TextEditingController(); // Controller cho TextField
  double _rating = 0.0; // Biến lưu đánh giá sao

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarProfile(title: 'Evaluate'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 120,
              margin: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.product['ImageUrl'],
                    fit: BoxFit.fill,
                    width: 80,
                    height: 200,
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.product['Name'],
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xff32343E),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.product['Price'].toString()} VND',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xffA02334),
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Phần nhập bình luận
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Đánh giá sao
                  const Text(
                    'Rate this Product:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < _rating ? Icons.star : Icons.star_border,
                          color: Colors.orange,
                          size: 30,
                        ),
                        onPressed: () {
                          setState(() {
                            _rating = (index + 1).toDouble(); // Đảm bảo _rating là kiểu double
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Write a Comment:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),

                  TextField(
                    controller: _commentController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Enter your comment here...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.orange),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Đảm bảo các giá trị đều hợp lệ
                          if (_commentController.text.isNotEmpty && _rating > 0) {
                            controller.addOrderToFirestore(
                              userId: controllerId.userId.toString(),
                              idProduct: widget.product['id'],
                              nameProduct: widget.product['Name'],
                              comment: _commentController.text,
                              total: (widget.product['Price'] as int).toDouble(),
                              evalua: _rating,
                              nameUser: controllerPro.userData['fullName']?.toString() ?? 'User'
                            );
                            _rating = 0.0;
                            _commentController.clear();
                          } else {
                            // Nếu người dùng chưa nhập đánh giá hoặc bình luận
                            Get.snackbar(
                              'Error',
                              'Please provide a rating and a comment',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange, // Màu nền nút
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Submit Evaluate',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
