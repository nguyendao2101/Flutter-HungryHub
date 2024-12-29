// ignore_for_file: prefer_const_constructors_in_immutables, unused_element

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hungry_hub/view_model/home_view_model.dart';
import 'package:flutter_hungry_hub/widgets/common/image_extention.dart';
import 'package:flutter_hungry_hub/widgets/common_widget/food_detail/rating_star.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../model/location/location_model.dart';
import '../../../view/test.dart';
import '../../../view_model/elvaluate_product_view_model.dart';
import '../button/bassic_button.dart';
import '../text/title_see_more.dart';

class FoodDetail extends StatefulWidget {
  final Map<String, dynamic> productDetail;

  // Constructor receives productDetail as a map.
  FoodDetail({super.key, required this.productDetail});

  @override
  State<FoodDetail> createState() => _FoodDetailState();
}

class _FoodDetailState extends State<FoodDetail> {
  final controller = Get.put(HomeViewModel());
  final controllerEvalua = Get.put(ElvaluateProductViewModel());
  final TextEditingController _commentController = TextEditingController(); // Controller cho TextField
  double _rating = 0.0; // Biến lưu đánh giá sao
  late Future<double> averageRating; // Lưu trữ giá trị trung bình đánh giá
  late Future<List<Map<String, String>>> evaluations; // Lưu trữ danh sách đánh giá

  @override
  void initState() {
    super.initState();
    averageRating = controllerEvalua.getAverageEvaluationByProduct(widget.productDetail['id']);
    evaluations = controllerEvalua.getEvaluationsByProduct(widget.productDetail['id']);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    height: 36,
                    width: 36,
                    decoration: const BoxDecoration(
                      shape: BoxShape
                          .circle, // Đặt hình dạng của container là hình tròn
                      color: Color(0xffD9D9D9),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        ImageAsset.backButton,
                        height: 5,
                        width: 6,
                      ),
                    )),
              ),
              SizedBox(
                width: 24, // Tăng kích thước để dễ nhấn hơn
                height: 24,
                child: PopupMenuButton<int>(
                  color: Colors.white,
                  offset: const Offset(-10, 15),
                  elevation: 1,
                  icon: SvgPicture.asset(
                    ImageAsset.more,
                    width: 12,
                    height: 12,
                  ),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: 1,
                        height: 30,
                        child: InkWell(
                          onTap: () {},
                          child: const Text(
                            "Report",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff32343E),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                    ];
                  },
                ),
              )
            ],
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Container(
                  height: 211,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(20), // Chỉnh góc bo tròn
                    border: Border.all(
                        color: Colors.white,
                        width: 2), // Đường viền của container
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        20), // Đảm bảo ảnh cũng có góc bo tròn như container
                    child: Image.network(
                      widget.productDetail['ImageUrl'],
                      fit: BoxFit.fill, // Làm ảnh fill toàn bộ container
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '${widget.productDetail['Price']} VNĐ',
                style: const TextStyle(
                  fontSize: 20,
                  color: Color(0xffA02334),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.productDetail['Name'],
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xff32343E),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.productDetail['Description'],
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xff32343E),
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                    ),
                    softWrap: true, // Bật chế độ tự xuống dòng
                    overflow: TextOverflow.visible, // Hiển thị toàn bộ nội dung
                  ),
                ],
              ),

              const SizedBox(height: 16,),
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: BasicAppButton(
                  onPressed: () {
                    controller.addToShoppingCart(widget.productDetail);
                  },
                  title: 'ADD',
                  sizeTitle: 14,
                  colorButton: const Color(0xffFF7622),
                  radius: 12,
                  fontW: FontWeight.bold,
                  height: 62,
                ),
              ),
              const TitleSeeMore(
                title: 'Product Review',
              ),
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
                          (eval) => Column(
                        children: [
                          const Divider(),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start, // Đảm bảo căn chỉnh các thành phần theo trục trên cùng
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.shade300,
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    ImageAsset.users,
                                    height: 40,
                                    width: 40,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded( // Đặt nội dung văn bản trong `Expanded` để hỗ trợ xuống dòng
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      eval['nameUser'] ?? 'Unknown',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff32343E),
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins',
                                      ),
                                      overflow: TextOverflow.clip, // Hiển thị toàn bộ nội dung
                                      softWrap: true, // Cho phép xuống dòng
                                    ),
                                    const SizedBox(height: 5), // Thêm khoảng cách giữa các văn bản
                                    Text(
                                      eval['comment'] ?? 'No comment',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff32343E),
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Poppins',
                                      ),
                                      overflow: TextOverflow.clip, // Hiển thị toàn bộ nội dung
                                      softWrap: true, // Cho phép xuống dòng
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                        ],
                      ),
                    )
                        .toList(),
                  );
                },
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _popupMenuItem(String text) {
    return PopupMenuItem(
      value: 1,
      height: 30,
      child: Text(
        text,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
  double _getRatingValue(dynamic ratingValue) {
    if (ratingValue == null) {
      return 0.0; // Trả về giá trị sao mặc định nếu không có đánh giá
    }

    // Kiểm tra kiểu dữ liệu của ratingValue và chuyển đổi
    if (ratingValue is double) {
      return ratingValue;
    } else if (ratingValue is int) {
      return ratingValue.toDouble();
    }

    return 0.0; // Trả về giá trị mặc định nếu không thể chuyển đổi
  }
}
