import 'package:flutter/material.dart';
import 'package:flutter_hungry_hub/widgets/common/image_extention.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Pay extends StatefulWidget {
  const Pay({super.key});

  @override
  State<Pay> createState() => _PayState();
}

class _PayState extends State<Pay> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center, // Căn giữa các phần tử trong Row
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Quay lại màn hình trước
                },
                child: Container(
                  height: 36,
                  width: 36,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle, // Hình tròn
                    color: Color(0xffD9D9D9), // Màu nền
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
              const Spacer(), // Tạo khoảng trống giữa nút quay lại và tiêu đề
              const Text(
                'Pay Your Order',
                style: TextStyle(
                  fontSize: 24,
                  color: const Color(0xff32343E),
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
              const Spacer(), // Tạo khoảng trống nếu cần thiết
            ],
          )
        ),
        body: Center(
          child: Text('Pay'),
        ),
      ),
    );
  }
}
