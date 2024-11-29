import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hungry_hub/widgets/common_widget/button/bassic_button.dart';
import 'package:get/get.dart';
import '../view_model/sign_up_view_model.dart';
import 'login_view.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpViewModel());
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
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: Color(0xffF44336),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                _formEmail(controller),
                const SizedBox(height: 16),
                _formPassword(controller),
                const SizedBox(height: 16),
                _formEntryPassword(controller),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Full Name',
                  hintText: 'Full Name',
                  obscureText: false,
                  onChanged: controller.onChangeCheckName,
                  validator: controller.validatorCheck,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Address',
                  hintText: 'Address',
                  obscureText: false,
                  onChanged: controller.onChangeCheckAdress,
                  validator: controller.validatorCheck,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Sex',
                  hintText: 'Sex',
                  obscureText: false,
                  onChanged: controller.onChangeCheckSex,
                  validator: controller.validatorCheck,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Phone Number',
                  hintText: 'Phone Number',
                  obscureText: false,
                  onChanged: controller.onChangeCheckNumberPhone,
                  validator: controller.validatorCheck,
                ),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Obx(() {
                    // return BasicAppButton(onPressed: (){
                    //
                    // }, title: 'SIGN IN', sizeTitle: 16, fontW: FontWeight.bold, height: 53, radius: 12,);
                    return ElevatedButton(
                      onPressed: () {
                        if (controller.isValidSignupForm()) {
                          controller.isLoading.value = true;
                          controller.signUp(
                            controller.email ?? '',
                            controller.password ?? '',
                            controller.confirmPassword ?? '',
                            controller.hoTen ?? '',
                            controller.address ?? '',
                            controller.sex ?? '',
                            controller.numberPhone ?? '',
                                () {
                              controller.isLoading.value = false;
                              Get.snackbar(
                                'Success',
                                'Đăng ký thành công',
                                snackPosition: SnackPosition.TOP,
                              );
                              controller.resetForm();
                              Get.offAll(() => const LoginView());
                            },
                                (error) {
                              controller.isLoading.value = false;
                              Get.snackbar(
                                'Error',
                                error,
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            },
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffE53935),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 150),
                      ),
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }),
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
              color: Color(0xff939393), fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 16), // Chữ màu đen để dễ nhìn trên nền trắng
          decoration: InputDecoration(
            labelText: 'Password',
            labelStyle:
            const TextStyle(color: Color(0xff939393), fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 16), // Nhãn màu xám nhạt
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8), // Bo góc đường viền
              borderSide: BorderSide(
                  color: Colors.grey.shade400, width: 1), // Viền màu xám
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                  color: Colors.blue, width: 1), // Viền màu xanh khi được chọn
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                  color: Colors.red, width: 1), // Viền màu đỏ khi có lỗi
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                  color: Colors.redAccent,
                  width: 2), // Viền đỏ khi có lỗi và đang được chọn
            ),
            filled: true,
            fillColor: Colors.grey[200], // Màu nền xám nhạt cho trường nhập
            hintText: 'Password',
            hintStyle: TextStyle(
                color: Color(0xff939393), fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 16), // Gợi ý màu xám nhạt
            suffixIcon: GestureDetector(
              onTap: () => controller.toggleObscureText(),
              child: Icon(
                controller.isObscured.value
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: Colors.grey.withOpacity(0.8), // Màu biểu tượng mắt
              ),
            ),
          ),
          onChanged: controller.onChangePassword,
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
              color: Color(0xff939393), fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 16), // Chữ màu đen để dễ nhìn trên nền trắng
          decoration: InputDecoration(
            labelText: 'Password',
            labelStyle:
            const TextStyle(color: Color(0xff939393), fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 16), // Nhãn màu xám nhạt
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8), // Bo góc đường viền
              borderSide: BorderSide(
                  color: Colors.grey.shade400, width: 1), // Viền màu xám
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                  color: Colors.blue, width: 1), // Viền màu xanh khi được chọn
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                  color: Colors.red, width: 1), // Viền màu đỏ khi có lỗi
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                  color: Colors.redAccent,
                  width: 1), // Viền đỏ khi có lỗi và đang được chọn
            ),
            filled: true,
            fillColor: Colors.grey[200], // Màu nền xám nhạt cho trường nhập
            hintText: 'Password',
            hintStyle: TextStyle(
                color: Color(0xff939393), fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 16), // Gợi ý màu xám nhạt
            suffixIcon: GestureDetector(
              onTap: () => controller.toggleEntryPasswordObscureText(),
              child: Icon(
                controller.isEntryPasswordObscured.value
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: Colors.grey.withOpacity(0.8), // Màu biểu tượng mắt
              ),
            ),
          ),
          onChanged: controller.onChangeConfirmPassword,
          validator: controller.validatorConfirmPassword,
        ),
      ),
    );
  }
  Padding _formEmail(SignUpViewModel controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        obscureText: false,
        style: const TextStyle(
            color: Color(0xff939393), fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 16), // Chữ màu đen để hiển thị rõ trên nền trắng
        decoration: InputDecoration(
          labelText: 'Email',
          labelStyle: const TextStyle(color: Color(0xff939393), fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 16), // Nhãn màu xám nhạt
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8), // Bo góc đường viền
            borderSide: BorderSide(
                color: Colors.grey.shade400, width: 1), // Viền màu xám nhạt
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
                color: Colors.blue, width: 1), // Viền màu xanh khi được chọn
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
                color: Colors.red, width: 1), // Viền màu đỏ khi có lỗi
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
                color: Colors.redAccent,
                width: 2), // Viền đỏ khi có lỗi và đang được chọn
          ),
          filled: true,
          fillColor: Colors.grey[200], // Màu nền xám nhạt cho trường nhập
          hintText: 'Email',
          hintStyle: TextStyle(
              color: Color(0xff939393), fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 16), // Gợi ý màu xám nhạt
        ),
        onChanged: controller.onChangeUsername,
        validator: controller.validatorUsername,
      ),
    );
  }

  // Hàm tái sử dụng cho các trường nhập liệu
  Padding _buildTextField({
    required String label,
    required String hintText,
    required bool obscureText,
    required Function(String) onChanged,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        obscureText: obscureText,
        style: const TextStyle(color: Color(0xff939393), fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xff939393), fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 16),
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
          hintText: hintText,
          hintStyle: TextStyle(color: Color(0xff939393), fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 16),
        ),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
  String generateVerificationCode() {
    var random = Random();
    return (random.nextInt(9000) + 1000).toString(); // Tạo số từ 1000 đến 9999
  }
}
