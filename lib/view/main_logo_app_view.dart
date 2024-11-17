import 'package:flutter/material.dart';
import 'package:flutter_hungry_hub/widgets/common/image_extention.dart';
import 'package:get/get.dart';
import '../view_model/main_nav_view_model.dart';

class MainLogoAppView extends StatefulWidget {
  const MainLogoAppView({super.key});

  @override
  State<MainLogoAppView> createState() => _MainLogoAppViewState();
}

class _MainLogoAppViewState extends State<MainLogoAppView> {
  final controller = Get.put(MainNavViewModel());

  @override
  void initState() {
    super.initState();
    controller.loadView();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(ImageAsset.loadLogoApp, height: 480, width: 339,),
      ),
    );
  }
}
