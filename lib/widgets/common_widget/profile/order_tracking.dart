import 'package:flutter/material.dart';

import 'app_bar_profile.dart';

class OrderTracking extends StatelessWidget {
  const OrderTracking({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBarProfile(title: 'Order Tracking'),
    body: Center(
        child: Text('Order Tracking'),
      ),
    );
  }
}
