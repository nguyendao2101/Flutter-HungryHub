import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import '../../common/image_extention.dart';
import '../card/product_grid_view.dart';
import '../text/title.dart';

class DrinksAndDessertsView extends StatelessWidget {
  final RxList<Map<String, dynamic>> listDS;
  const DrinksAndDessertsView({super.key, required this.listDS});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
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
              const SizedBox(
                width: 10,
              ),
              const Text(
                'Drinks And DessertsView',
                style: TextStyle(
                  fontSize: 24,
                  color: Color(0xff32343E),
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              )
            ],
          )),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 8),
              child: TitleFood(
                text: 'Fried Chicken - Roast Chicken',
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: listDS.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Hiển thị 2 sản phẩm mỗi hàng
                        crossAxisSpacing: 5.0, // Khoảng cách ngang giữa các ô
                        mainAxisSpacing: 5.0, // Khoảng cách dọc giữa các ô
                        childAspectRatio:
                            0.8, // Tỷ lệ giữa chiều rộng và chiều cao
                      ),
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: listDS
                          .where((product) =>
                              product['Category'] == 'Thức uống & tráng miệng')
                          .length, // Lọc sản phẩm theo category
                      itemBuilder: (context, index) {
                        final filteredProducts = listDS
                            .where((product) =>
                                product['Category'] ==
                                'Thức uống & tráng miệng')
                            .toList(); // Lọc sản phẩm ngay từ đầu
                        final product =
                            filteredProducts[index]; // Sử dụng danh sách đã lọc

                        // Hiển thị sản phẩm phù hợp
                        return ProductGridView(
                          product: product,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
