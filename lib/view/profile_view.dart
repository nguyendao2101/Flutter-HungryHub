import 'package:flutter/material.dart';
import 'package:flutter_hungry_hub/view_model/profile_view_model.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../widgets/common/image_extention.dart';
import '../widgets/common_widget/profile/function_profile.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final controller = Get.put(ProfileViewModel());
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
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
                  const SizedBox(width: 10,),
                  const Text('Profile', style: TextStyle(
                    fontSize: 17,
                    color: Color(0xff303030),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                  ),)
                ],
              ),
              Container(
                width: 36, // Tăng kích thước để dễ nhấn hơn
                height: 36,
                decoration: const BoxDecoration(
                  shape: BoxShape
                      .circle, // Đặt hình dạng của container là hình tròn
                  color: Color(0xffD9D9D9),
                ),
                child: Center(
                  child: PopupMenuButton<int>(
                    color: Colors.white,
                    offset: const Offset(-10, 15),
                    elevation: 1,
                    icon: SvgPicture.asset(
                      ImageAsset.profileMore,
                      width: 24,
                      height: 24,
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
                ),
              )
            ],
          )),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              const SizedBox(height: 30,),
              Container(
                width: 90,
                height: 90,
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
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 8),
                child: Text(controller.userData['fullName']?.toString() ?? 'User', style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xff111A2C),
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),),
              ),
              const Text('Explore the food', style: TextStyle(
                fontSize: 12,
                color: Color(0xff111A2C),
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
              ),),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                child: Container(
                  height: 170,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: const Color(0xffF0F0F0).withOpacity(0.6)
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 15, left: 16, right: 20),
                      child: Column(
                        children: [
                          FunctionProfile(image: ImageAsset.personalInfo, title: 'Personal Info',),
                          const SizedBox(height: 8,),
                          FunctionProfile(image: ImageAsset.GPS, title: 'Addresses',),
                          const SizedBox(height: 8,),
                          FunctionProfile(image: ImageAsset.GPS, title: 'Order tracking',),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                child: Container(
                  height: 214,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: const Color(0xffF0F0F0).withOpacity(0.6)
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 15, left: 16, right: 20),
                      child: Column(
                        children: [
                          FunctionProfile(image: ImageAsset.cartPlus, title: 'Cart',),
                          const SizedBox(height: 8,),
                          FunctionProfile(image: ImageAsset.favourist, title: 'Favourite',),
                          const SizedBox(height: 8,),
                          FunctionProfile(image: ImageAsset.notification, title: 'Notification',),
                          const SizedBox(height: 8,),
                          FunctionProfile(image: ImageAsset.wallet, title: 'Payment Method',),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  controller.onLogout();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                  child: Container(
                    height: 70,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0xffF0F0F0).withOpacity(0.6)
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 18, bottom: 15, left: 16, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                    height: 36,
                                    width: 36,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape
                                          .circle, // Đặt hình dạng của container là hình tròn
                                      color: Color(0xffFFFFFF),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        ImageAsset.logOut,
                                      ),
                                    )),
                                const SizedBox(width: 20,),
                                const Text('Log Out', style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xff111A2C),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins',
                                ),),
                              ],
                            ),
                            SvgPicture.asset(ImageAsset.arrowRight),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
