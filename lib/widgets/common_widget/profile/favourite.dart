import 'package:flutter/material.dart';

import 'app_bar_profile.dart';

class Favourite extends StatelessWidget {
  const Favourite({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarProfile(title: 'Favourite'),
      body: Center(
        child: Text('favourite'),
      ),
    );
  }
}
