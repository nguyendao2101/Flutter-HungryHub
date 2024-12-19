import 'package:flutter/material.dart';

import 'app_bar_profile.dart';

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarProfile(title: 'Payment Method'),
      body: Center(
        child: Text('Payment Method'),
      ),
    );
  }
}
