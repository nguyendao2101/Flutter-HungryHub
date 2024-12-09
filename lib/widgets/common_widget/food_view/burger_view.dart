import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class BurgerView extends StatelessWidget {
  final RxList<Map<String, dynamic>> listDS;
  const BurgerView({super.key, required this.listDS});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Burger'),
      ),
    );
  }
}
