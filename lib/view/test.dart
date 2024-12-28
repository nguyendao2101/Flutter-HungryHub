import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view_model/elvaluate_product_view_model.dart';
import '../view_model/orders_view_model.dart';
import '../widgets/common_widget/profile/app_bar_profile.dart';

class Test extends StatefulWidget {
  final Map<String, dynamic> product;
  const Test({super.key, required this.product});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  final controller = Get.put(ElvaluateProductViewModel());
  final controllerId = Get.put(OrdersViewModel());

  final TextEditingController _commentController = TextEditingController(); // Controller cho TextField
  double _rating = 0.0; // Biến lưu đánh giá sao
  late Future<double> averageRating; // Lưu trữ giá trị trung bình đánh giá
  late Future<List<Map<String, String>>> evaluations; // Lưu trữ danh sách đánh giá

  @override
  void initState() {
    super.initState();
    averageRating = controller.getAverageEvaluationByProduct(widget.product['id']);
    evaluations = controller.getEvaluationsByProduct(widget.product['id']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarProfile(title: 'Evaluate'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hiển thị thông tin sản phẩm
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
            // Hiển thị đánh giá trung bình
            FutureBuilder<double>(
              future: averageRating,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Average Rating:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(5, (index) {
                        return Icon(
                          index < snapshot.data! ? Icons.star : Icons.star_border,
                          color: Colors.orange,
                          size: 30,
                        );
                      }),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
            // Hiển thị danh sách bình luận
            FutureBuilder<List<Map<String, String>>>(
              future: evaluations,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: snapshot.data!
                      .map(
                        (eval) => ListTile(
                      title: Text(eval['name'] ?? 'Unknown'),
                      subtitle: Text(eval['comment'] ?? 'No comment'),
                    ),
                  )
                      .toList(),
                );
              },
            ),
            // Phần nhập bình luận và đánh giá sao (như trong mã ban đầu)
          ],
        ),
      ),
    );
  }
}
