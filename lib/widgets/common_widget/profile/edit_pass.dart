import 'package:flutter/material.dart';
import 'package:flutter_hungry_hub/view/login_view.dart';
import 'package:flutter_hungry_hub/view_model/login_view_model.dart';
import 'package:get/get.dart';
import '../../../view_model/sign_up_view_model.dart';
import '../../../view_model/orders_view_model.dart';
import '../../../model/firebase/firebase_authencation.dart';
import '/widgets/common_widget/check_mail/check_mail.dart';
import 'package:flutter_hungry_hub/widgets/common_widget/profile/persionnal_info.dart';
import 'package:flutter_hungry_hub/view_model/profile_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> updatePassword(
    String currrentEmail, String currentPassword, String newPassword) async {
  try {
    // Lấy người dùng hiện tại
    User? user = FirebaseAuth.instance.currentUser;
    print("esword :${currrentEmail}");
    print("Password :${currentPassword}");
    if (user != null) {
      // Tạo đối tượng EmailAuthCredential với email và mật khẩu hiện tại
      AuthCredential credential = EmailAuthProvider.credential(
        email: currrentEmail,
        password: currentPassword,
      );

      // Xác thực lại người dùng
      await user.reauthenticateWithCredential(credential);

      // Cập nhật mật khẩu sau khi xác thực thành công
      await user.updatePassword(newPassword);
      print("Password updated successfully.");

      // Reload lại thông tin người dùng
      await user.reload();
      user = FirebaseAuth
          .instance.currentUser; // Lấy lại thông tin người dùng sau khi reload

      print("New email: ${newPassword}");
    } else {
      print("No user is logged in.");
    }
  } catch (e) {
    print("Error updating password: $e");
  }
}

class EditPassView extends StatefulWidget {
  const EditPassView({super.key});

  @override
  State<EditPassView> createState() => _EditPassViewState();
}

class _EditPassViewState extends State<EditPassView> {
  late String codeMail;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpViewModel());

    final controller2 = Get.put(OrdersViewModel());
    RxString user_id = controller2.userId;

    final controller3 = Get.put(LoginViewModel());
    
    final controller4 = Get.put(LoginView());

    final controller5 = Get.put(ProfileViewModel());
    codeMail = controller.generateVerificationCode().toString();

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                const SizedBox(height: 24),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Change Password',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: Color(0xffF44336),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _formPassword2(controller),
                const SizedBox(height: 32),
                _formPassword(controller),
                const SizedBox(height: 16),
                _formEntryPassword(controller),
                
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: 
                     ElevatedButton(
                      onPressed: () {
                        /*if (controller.isValidSignupForm()) {
                          controller.sendEmail(
                              controller.email, codeMail.toString());
                          print('test ma code1: $codeMail');
                          // Di chuyển đến trang CheckMail
                        }*/
                        updatePassword(controller5.userData['email'],controller.x, controller.password);
                        
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffE53935),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 100),
                      ),
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'Continue',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _formPassword(SignUpViewModel controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Obx(
        () => TextFormField(
          obscureText: controller.isObscured.value,
          style: const TextStyle(
              color: Color(0xff939393),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 16),
          decoration: InputDecoration(
            labelText: 'New Password',
            labelStyle: const TextStyle(
                color: Color(0xff939393),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1),
            ),
            filled: true,
            fillColor: Colors.grey[200],
            hintText: 'New Password',
            hintStyle: const TextStyle(
                color: Color(0xff939393),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 16),
            suffixIcon: GestureDetector(
              onTap: () => controller.toggleObscureText(),
              child: Icon(
                controller.isObscured.value
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: Colors.grey.withOpacity(0.8),
              ),
            ),
          ),
          onChanged: controller.onChangePassword,
          validator: controller.validatorPassword,
        ),
      ),
    );
  }

  Padding _formPassword2(SignUpViewModel controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Obx(
        () => TextFormField(
          obscureText: controller.isObscured.value,
          style: const TextStyle(
              color: Color(0xff939393),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 16),
          decoration: InputDecoration(
            labelText: 'Current Password',
            labelStyle: const TextStyle(
                color: Color(0xff939393),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1),
            ),
            filled: true,
            fillColor: Colors.grey[200],
            hintText: 'Current Password',
            hintStyle: const TextStyle(
                color: Color(0xff939393),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 16),
            suffixIcon: GestureDetector(
              onTap: () => controller.toggleObscureText(),
              child: Icon(
                controller.isObscured.value
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: Colors.grey.withOpacity(0.8),
              ),
            ),
          ),
          onChanged: controller.onChangeX,
          validator: controller.validatorPassword,
        ),
      ),
    );
  }

  Padding _formEntryPassword(SignUpViewModel controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Obx(
        () => TextFormField(
          obscureText: controller.isEntryPasswordObscured.value,
          style: const TextStyle(
              color: Color(0xff939393),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 16),
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            labelStyle: const TextStyle(
                color: Color(0xff939393),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1),
            ),
            filled: true,
            fillColor: Colors.grey[200],
            hintText: 'Confirm Password',
            hintStyle: const TextStyle(
                color: Color(0xff939393),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 16),
            suffixIcon: GestureDetector(
              onTap: () => controller.toggleEntryPasswordObscureText(),
              child: Icon(
                controller.isEntryPasswordObscured.value
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: Colors.grey.withOpacity(0.8),
              ),
            ),
          ),
          onChanged: controller.onChangeConfirmPassword,
          validator: controller.validatorConfirmPassword,
        ),
      ),
    );
  }
}
