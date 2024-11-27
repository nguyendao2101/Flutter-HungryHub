import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'sign_up_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
            onTap: () {
              Get.to(() => SignUpView());
            },
            child: Text('Get to sign up')),
      ),
    );
  }
}
