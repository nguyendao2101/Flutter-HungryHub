import 'package:flutter/material.dart';

import 'app_bar_profile.dart';

class NotificationPro extends StatelessWidget {
  const NotificationPro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarProfile(title: 'Notification'),
      body: Center(
        child: Text('Notification'),
      ),
    );
  }
}
