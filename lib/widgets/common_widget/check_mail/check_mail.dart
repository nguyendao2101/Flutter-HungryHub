import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hungry_hub/widgets/common_widget/button/bassic_button.dart';
import 'package:get/get.dart';

import '../../../view/login_view.dart';
import '../../../view_model/sign_up_view_model.dart';

class CheckMail extends StatefulWidget {
  final String email;
  final String password;
  final String fullName;
  final String address;
  final String sex;
  final String phoneNumber;
  final String verificationCode; // Mã xác minh từ controller

  const CheckMail({
    super.key,
    required this.email,
    required this.password,
    required this.fullName,
    required this.address,
    required this.sex,
    required this.phoneNumber,
    required this.verificationCode, // Thêm mã xác minh
  });

  @override
  State<CheckMail> createState() => _CheckMailState();
}

class _CheckMailState extends State<CheckMail> {
  final controller = Get.put(SignUpViewModel());
  late String codeMail;

  late Timer _timer;
  int _remainingSeconds = 90; // Thời gian đếm ngược (90s)
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel(); // Dừng timer khi không dùng nữa
    for (var controller in _controllers) {
      controller.dispose(); // Hủy controllers
    }
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel(); // Dừng timer khi về 0
      }
    });
  }
  void _resendCode() {
    // Hủy timer hiện tại nếu đang chạy
    _timer.cancel();
    setState(() {
      _remainingSeconds = 90; // Reset thời gian đếm ngược
    });
    startTimer(); // Bắt đầu lại timer
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Mã xác minh đã được gửi lại!'),
      backgroundColor: Colors.blue,
    ));
  }


  void _verifyCode() {
    String inputCode = _controllers.map((controller) => controller.text).join();
    if(_remainingSeconds<=0){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Thời gian đã hết vui long lấy lại 4-Digit'),
        backgroundColor: Colors.red,
      ));
    }
    else if (inputCode == widget.verificationCode) {
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Xác minh thành công!'),
        backgroundColor: Colors.green,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Mã xác minh không đúng.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    codeMail = controller.generateVerificationCode().toString();
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Text(widget.verificationCode),
              Text(
                'Verify \nyour email',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Enter the 4-Digit code sent to \nyou\non ${widget.email}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                  color: Color(0xff32343E),
                ),
              ),
              const SizedBox(height: 30),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: Color(0xff0D0D0D),
                  ),
                  children: [
                    const TextSpan(text: 'Didn’t receive ?'),
                    TextSpan(
                      text: ' Send again',
                      style: const TextStyle(color: Color(0xffFF0000)),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _resendCode(); // Gọi lại mã xác minh
                          controller.sendEmail(controller.email, codeMail.toString()); // Gửi lại email
                          print('code 2: $codeMail');
                        },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return Container(
                    width: 50,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: TextField(
                      controller: _controllers[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.length == 1 && index < 3) {
                          FocusScope.of(context).nextFocus();
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                    ),
                  );
                }),
              ),

              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Resend in ${formatTime(_remainingSeconds)}',
                    style: const TextStyle(
                      color: Color(0xff0D0D0D),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              BasicAppButton(onPressed: _verifyCode, title: 'SIGN UP', sizeTitle: 16, fontW: FontWeight.bold, colorButton: Color(0xffE53935), radius: 12,height: 53,),
              const SizedBox(height: 50),
              Align(
                alignment: Alignment.center,
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      color: Color(0xff868686),
                    ),
                    children: [
                      TextSpan(text: 'By signing up, you have agreed to our\n'),
                      TextSpan(
                        text: 'Terms and conditions',
                        style: TextStyle(color: Color(0xff3567E7)),
                      ),
                      TextSpan(text: '&'),
                      TextSpan(
                        text: ' Privacy policy',
                        style: TextStyle(color: Color(0xff3567E7)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm định dạng thời gian (phút:giây)
  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
