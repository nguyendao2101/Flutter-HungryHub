import 'package:flutter/material.dart';
import 'package:flutter_hungry_hub/view/main_nav_view.dart';
import 'package:flutter_hungry_hub/widgets/common_widget/order_tracking/confim_order.dart';
import 'package:flutter_hungry_hub/widgets/common_widget/order_tracking/delivered_order.dart';
import 'package:flutter_hungry_hub/widgets/common_widget/order_tracking/waiting_for_delivery.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../common/image_extention.dart';
import 'app_bar_profile.dart';

class OrderTracking extends StatefulWidget {
  final int initialIndex;
  const OrderTracking({super.key, required this.initialIndex});

  @override
  State<OrderTracking> createState() => _OrderTrackingState();
}

class _OrderTrackingState extends State<OrderTracking> with SingleTickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  Get.offAll(()=> const MainNavView(initialIndex: 3));
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
            ),
            const Text(
              'Order Tracking',
              style: const TextStyle(
                fontSize: 24,
                color: Color(0xff32343E),
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            floating: true, // AppBar cuộn theo nội dung
            snap: true, // AppBar xuất hiện ngay khi người dùng vuốt nhẹ lên
            pinned: true, // Giữ lại AppBar khi cuộn
            primary: false, // Vô hiệu hóa việc tính toán AppBar với phần đầu
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.zero,
              background: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TabBar(
                    controller: tabController,
                    indicatorColor: Colors.red,
                    indicatorWeight: 3,
                    labelColor: Colors.red,
                    labelStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                    isScrollable: false, // Không cho phép cuộn các tab
                    tabs: const [
                      Tab(text: 'Confirm'),
                      Tab(text: 'Waiting Delivery'),
                      Tab(text: 'Delivered'),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: tabController,
              physics: NeverScrollableScrollPhysics(), // Tắt vuốt ngang
              children: const [
                ConfimOrder(),
                WaitingForDelivery(),
                DeliveredOrder(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
