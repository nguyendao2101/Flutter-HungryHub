import 'package:flutter_hungry_hub/view/login_view.dart';
import 'package:get/get.dart';

class MainNavViewModel extends GetxController{
  void loadView() async {
    await Future.delayed(const Duration(seconds: 3));
    Get.to(() => const LoginView());
  }
}