import 'package:flutter/material.dart';

import 'app_bar_profile.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarProfile(title: 'Cart'),
      body: Center(
        child: Text('Cart'),
      ),
    );
  }
}
