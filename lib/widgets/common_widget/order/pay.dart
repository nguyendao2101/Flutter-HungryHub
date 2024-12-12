import 'package:flutter/material.dart';
import 'package:flutter_hungry_hub/view_model/orders_view_model.dart';
import 'package:flutter_hungry_hub/widgets/common/image_extention.dart';
import 'package:flutter_hungry_hub/widgets/common_widget/button/bassic_button.dart';
import 'package:flutter_hungry_hub/widgets/common_widget/order/select_payment.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../evaluate/evaluate.dart';

class Pay extends StatefulWidget {
  List<Map<String, dynamic>> product;
  Pay({super.key, required this.product});

  @override
  State<Pay> createState() => _PayState();
}

class _PayState extends State<Pay> {
  final controller = Get.put(OrdersViewModel());
  TextEditingController couponController = TextEditingController();
  double coupon = 0;  // Khai báo coupon là biến trạng thái
  double delivery = 30000;  // Khai báo coupon là biến trạng thái

  @override
  Widget build(BuildContext context) {
    double total1 = controller.calculateTotal(widget.product);  // Cập nhật tổng tiền với coupon
    double total = controller.calculateTotal(widget.product) - coupon + delivery;  // Cập nhật tổng tiền với coupon
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 36,
                  width: 36,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffD9D9D9),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      ImageAsset.backButton,
                      height: 5,
                      width: 6,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              const Text(
                'Pay Your Order',
                style: TextStyle(
                  fontSize: 24,
                  color: const Color(0xff32343E),
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // ListView.builder
              ListView.builder(
                itemCount: widget.product.length,
                shrinkWrap: true,  // Đảm bảo ListView không chiếm quá nhiều không gian
                physics: const NeverScrollableScrollPhysics(), // Tắt cuộn trong ListView
                itemBuilder: (context, index) {
                  final item = widget.product[index];
                  return Container(
                    height: 100,
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
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
                          item['ImageUrl'],
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
                            item['Name'],
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xff32343E),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${item['Price'].toString()} VND',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xffA02334),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const Evaluate(height: 24, width: 71),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Quantity: ${item['Quantity'].toString()}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xff32343E),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: couponController,
                        decoration: InputDecoration(
                          hintText: 'Add Promo code',
                          hintStyle: const TextStyle(
                            fontSize: 16,
                            color: Color(0xff32343E),
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                          ),
                          border: InputBorder.none, // Bỏ viền
                          filled: true,
                          fillColor: Colors.grey[200],
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), // Điều chỉnh padding để căn chỉnh nội dung
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide.none, // Bỏ viền khi không focus
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide.none, // Bỏ viền khi có focus
                          ),
                        ),
                      ),

                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        String enteredCode = couponController.text.trim(); // Lấy giá trị từ TextField
                        var matchingCoupon = controller.coupons.firstWhere(
                              (coupon) => coupon['id'] == enteredCode,
                          orElse: () => {}, // Trả về một map rỗng khi không tìm thấy
                        );

                        if (matchingCoupon.isNotEmpty) {
                          // Nếu tìm thấy mã giảm giá
                          print('Coupon found: ${matchingCoupon['coupon']} VND');
                          setState(() {
                            coupon = matchingCoupon['coupon'].toDouble();  // Cập nhật coupon khi tìm thấy
                          });
                        } else {
                          // Nếu không tìm thấy mã giảm giá
                          print('Invalid coupon code');
                          setState(() {
                            coupon = 0;  // Đặt lại coupon nếu không tìm thấy
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color(0xffFBFBFB),
                        backgroundColor: const Color(0xffEF5350), // Màu chữ khi button được nhấn
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4), // Bo góc với bán kính 12
                        ),
                      ),
                      child: const Text('Apply'),
                    ),
                  ],
                ),
              ),
              _moneyToTal('Total', total1, const Color(0xff5B645F)),
              _moneyToTal('Delivery fees', delivery, const Color(0xff5B645F)),
              _moneyToTal('Promo', coupon, const Color(0xff5B645F)),
              _moneyToTal('Total', total, const Color(0xff0D0D0D)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: BasicAppButton(
                    onPressed: (){
                      Get.to(()=> SelectPayment());
                    },
                    title: 'Continue to payment', sizeTitle: 16, height: 62, radius: 12, colorButton: const Color(0xffFF7622), fontW: FontWeight.w500,),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget _moneyToTal(String title, double number, Color colorTitle){
    return Padding(
      padding:  const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(
            fontSize: 16,
            color: colorTitle,
            fontWeight: FontWeight.w400,
            fontFamily: 'Poppins',
          ),),
          Row(
            children: [
              Text(number.toString(), style: const TextStyle(
                fontSize: 16,
                color: Color(0xffA02334),
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
              ),),
              const SizedBox( width: 8,),
              const Text('VND', style: TextStyle(
                fontSize: 16,
                color: Color(0xff1C1B1F),
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
              ),),
            ],
          ),

        ],
      ),
    );
  }
}
