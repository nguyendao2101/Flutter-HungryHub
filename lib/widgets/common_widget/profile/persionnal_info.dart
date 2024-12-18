import 'package:flutter/material.dart';
import 'package:flutter_hungry_hub/view_model/profile_view_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../common/image_extention.dart';

class PersonalInfo extends StatelessWidget {
  const PersonalInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileViewModel());

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
              'Personal Info',
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
            const SizedBox(height: 30),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: AssetImage(ImageAsset.users),
            ),
            const SizedBox(height: 20),
            Text(
              controller.userData['fullName'] ?? '',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xff111A2C),
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 5),
            Text(
              controller.userData['email'] ?? '',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xff6C757D),
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 30),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildUserInfoTile(
                      title: 'Full Name',
                      value: controller.userData['fullName'],
                      icon: Icons.person,
                    ),
                    const Divider(),
                    _buildUserEmailTile(title: 'Email', icon: Icons.email, value: controller.userData['email']),
                    const Divider(),
                    _buildUserInfoTile(
                      title: 'Address',
                      value: controller.userData['address'],
                      icon: Icons.location_on,
                    ),
                    const Divider(),
                    _buildUserInfoTile(
                      title: 'Gender',
                      value: controller.userData['sex'],
                      icon: Icons.wc,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoTile({
    required String title,
    String? value,
    required IconData icon,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xff111A2C),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xff111A2C),
          fontFamily: 'Poppins',
        ),
      ),
      trailing: Text(
        value ?? 'N/A',
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Color(0xff6C757D),
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
  Widget _buildUserEmailTile({
    required String title,
    String? value,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: const Color(0xff111A2C),
                size: 20,
              ),
              const SizedBox(width: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff111A2C),
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value ?? 'N/A',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Color(0xff6C757D),
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

}
