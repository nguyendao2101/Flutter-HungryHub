import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hungry_hub/view/sign_up_view.dart';
import 'package:flutter_hungry_hub/widgets/common_widget/button/bassic_button.dart';
import 'package:get/get.dart';
import '../view_model/login_view_model.dart';
import '../widgets/common/image_extention.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final controller = Get.put(LoginViewModel());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      RichText(
                        text: const TextSpan(
                            style: TextStyle(fontSize: 24, color: Color(0xff32343E), fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                        children: [
                          TextSpan(
                            text: '  Just ',
                          ),
                          TextSpan(
                            text: 'Sign in ',
                            style: TextStyle(
                              color: Color(0xffF44336)
                            ),
                          ),
                          TextSpan(
                            text: ',we’ll\nprepar your order ',
                          ),
                        ]
                      ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      RichText(
                        text:  TextSpan(
                            style: const TextStyle(fontSize: 16, color: Color(0xff32343E), fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
                            children: [
                              const TextSpan(
                                text: 'If you don’t have an account\nplease ',
                              ),
                              TextSpan(
                                text: ' Sign up here',
                                style: const TextStyle(
                                    color: Color(0xffF44336)
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Chuyển màn hình sang SignUpScreen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const SignUpView(),
                                      ),
                                    );
                                  },
                              ),
                            ]
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      _formEmail(controller),
                      const SizedBox(
                        height: 20,
                      ),
                      _formPassword(controller),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff939393),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: BasicAppButton(onPressed: (){
                      if (controller.formKey.currentState?.validate() ==
                          true) {
                        controller.onlogin();
                        controller.emailController.clear();
                        controller.passwordController.clear();
                      }
                    }, title: 'SIGN IN', sizeTitle: 16, height: 53, radius: 12, colorButton: const Color(0xffE53935), fontW: FontWeight.bold,),
                  ),
                  const SizedBox(height: 40,),
                  _textOrContinueWith(),
                  const SizedBox(height: 20,),
                  InkWell(
                    onTap: (){},
                      child: _siginInWith(ImageAsset.facebook, 'Connect with facebook')),
                  const SizedBox(height: 8,),
                  InkWell(
                    onTap: (){},
                      child: _siginInWith(ImageAsset.google, 'Connect with Google')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding _siginInWith(String image, String text){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 54,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xffFBFBFB),
          border: Border.all(
            color: const Color(0xff9F9F9F), // Màu viền
            width: 2,           // Độ dày viền
            style: BorderStyle.solid, // Kiểu viền (solid, dashed, etc.)
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(image),
              const SizedBox(width: 4,),
               Text(text,
                style: const TextStyle(fontFamily: 'Poppins', color: Color(0xff0D0D0D), fontWeight: FontWeight.w500, fontSize: 14),),
            ],
          ),
        ),
      ),
    );
  }

  Padding _textOrContinueWith() {
    return const Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              'OR',
              style: TextStyle(
                  fontWeight: FontWeight.w500, color: Colors.black, fontSize: 16, fontFamily: 'Poppins'),
            ),
          ),
        ],
      ),
    );
  }

  Padding _formPassword(LoginViewModel controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Password', style: TextStyle(fontSize: 16, color: Color(0xff0D0D0D), fontWeight: FontWeight.w600, fontFamily: 'Poppins'),),
                const SizedBox(height: 8,),
                TextFormField(
                          controller: controller.passwordController,
                          obscureText: controller.isObscured.value,
                          style: const TextStyle(
                  color: Colors.black), // Chữ màu đen để dễ nhìn trên nền trắng
                          decoration: InputDecoration(
                // labelText: 'Password',
                // labelStyle:
                // const TextStyle(color: Colors.black), // Nhãn màu xám nhạt
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
                    color: Colors.grey.withOpacity(0.6)), // Gợi ý màu xám nhạt
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
              ],
            ),
      ),
    );
  }

  Padding _formEmail(LoginViewModel controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Email address', style: TextStyle(fontSize: 16, color: Color(0xff0D0D0D), fontWeight: FontWeight.w600, fontFamily: 'Poppins'),),
          const SizedBox(height: 8,),
          TextFormField(
            controller: controller.emailController,
            obscureText: false,
            style: const TextStyle(
                color: Colors.black), // Chữ màu đen để hiển thị rõ trên nền trắng
            decoration: InputDecoration(
              // labelText: 'Email',
              // labelStyle: const TextStyle(color: Colors.black), // Nhãn màu xám nhạt
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
                    width: 1), // Viền đỏ khi có lỗi và đang được chọn
              ),
              filled: true,
              fillColor: Colors.grey[200], // Màu nền xám nhạt cho trường nhập
              hintText: 'Email',
              hintStyle: TextStyle(
                  color: Colors.grey.withOpacity(0.6)), // Gợi ý màu xám nhạt
            ),
            onChanged: controller.onChangeUsername,
            validator: controller.validatorUsername,
          ),
        ],
      ),
    );
  }
}
