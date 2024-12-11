import 'package:flutter/material.dart';
import 'package:flutter_hungry_hub/view/load_image_panner_view.dart';
import 'package:get/get.dart';

class MainNavViewModel extends GetxController {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  void loadView() async {
    await Future.delayed(const Duration(seconds: 3));
    Get.to(() => const LoadImagePannerView());
  }

  // Quản lý chỉ số của tab được chọn
  RxInt selectedTab = 0.obs;

  // GlobalKey cho Scaffold (để hiển thị Snackbar, Drawer, v.v.)

  // Cập nhật tab được chọn
  void updateSelectedTab(int index) {
    selectedTab.value = index;
  }

  // Xử lý mở Drawer (nếu cần)
  void openDrawer() {
    if (scaffoldKey.currentState != null) {
      scaffoldKey.currentState!.openDrawer();
    }
  }
}
