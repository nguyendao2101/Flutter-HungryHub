import 'package:flutter/material.dart';
import 'package:flutter_hungry_hub/widgets/common_widget/profile/app_bar_profile.dart';
import 'package:flutter_svg/svg.dart';

import '../../common/image_extention.dart';

class Addresses extends StatelessWidget {
  const Addresses({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarProfile(title: 'Addresses'),
      body: Center(
        child: Text('Address'),
      ),
    );
  }
}
