import 'package:flutter/material.dart';
import 'package:flutter_hungry_hub/widgets/common/image_extention.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../evaluate/evaluate.dart';

class Pay extends StatefulWidget {
  List<Map<String, dynamic>> product;
  Pay({super.key, required this.product});

  @override
  State<Pay> createState() => _PayState();
}

class _PayState extends State<Pay> {
  // tinh tong so tien phai thanh toan
  double _calculateTotal() {
    double total = 0.0;
    for (var item in widget.product) {
      total += item['Price']*item['Quantity']; // Cộng dồn giá của mỗi sản phẩm
    }
    return total;
  }
  @override
  Widget build(BuildContext context) {
    double total = _calculateTotal();
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
                physics: NeverScrollableScrollPhysics(), // Tắt cuộn trong ListView
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
              Text('Tổng tiền thanh toán: $total'),
            ],
          ),
        ),
      ),
    );
  }
}

