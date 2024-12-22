import 'package:flutter/material.dart';
import 'package:flutter_hungry_hub/widgets/common_widget/button/bassic_button.dart';
import 'package:flutter_svg/svg.dart';

import '../widgets/common/image_extention.dart';

class RegisterShopView extends StatelessWidget {
  const RegisterShopView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              const Spacer(),
              Text('Register Shop'),
              const Spacer(),
              // SizedBox(
              //   width: 24, // Tăng kích thước để dễ nhấn hơn
              //   height: 24,
              //   child: PopupMenuButton<int>(
              //     color: Colors.white,
              //     offset: const Offset(-10, 15),
              //     elevation: 1,
              //     icon: SvgPicture.asset(
              //       ImageAsset.more,
              //       width: 12,
              //       height: 12,
              //     ),
              //     padding: EdgeInsets.zero,
              //     itemBuilder: (context) {
              //       return [
              //         PopupMenuItem(
              //           value: 1,
              //           height: 30,
              //           child: InkWell(
              //             onTap: () {},
              //             child: const Text(
              //               "Report",
              //               style: TextStyle(
              //                 fontSize: 14,
              //                 color: Color(0xff32343E),
              //                 fontWeight: FontWeight.w500,
              //                 fontFamily: 'Poppins',
              //               ),
              //             ),
              //           ),
              //         ),
              //       ];
              //     },
              //   ),
              // )
            ],
          )),
      body: Column(
        children: [
          const SizedBox(height: 100,),
          Image.asset(ImageAsset.check, height: 128,),
          const SizedBox(height: 100,),
          const Center(
              child: Text('The account has been transferred to the admin department!', style:  TextStyle(
            fontSize: 18,
            color: Color(0xff131010),
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
                textAlign: TextAlign.center,
              ),
          ),
          const SizedBox(height: 50,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 120),
            child: BasicAppButton(onPressed: (){
              Navigator.pop(context);
            }, title: 'Back', sizeTitle: 16, height: 50, fontW: FontWeight.w500, radius: 8,),
          )
        ],
      ),
    );
  }
}
