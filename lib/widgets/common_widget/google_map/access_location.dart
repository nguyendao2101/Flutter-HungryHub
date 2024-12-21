// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hungry_hub/view/main_nav_view.dart';
import 'package:flutter_hungry_hub/widgets/common/image_extention.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import '../../../model/location/location_model.dart';

class AccessLocation extends StatefulWidget {
  const AccessLocation({super.key});

  @override
  State<AccessLocation> createState() => _AccessLocationState();
}

class _AccessLocationState extends State<AccessLocation> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  String location = ' '; // Biến lưu vị trí hiện tại

  String getCity(String location) {
    List<String> parts = location.split(',');

    for (var part in parts) {
      if (part.contains('City')) {
        return part.split(':')[1].trim();
      }
    }
    return '';
  }

  Future<void> _uploadLocationToFirebase() async {
    try {
      // Lấy người dùng hiện tại từ Firebase Authentication
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        throw Exception("No user is signed in.");
      }

      String userId = currentUser.uid; // ID của người dùng hiện tại
      String locationData =
          await LocationService().getCurrentLocationAndAddress();

      // Ghi dữ liệu vị trí vào Firebase Realtime Database
      await _database.child('users/$userId/AddAdress/location').set(locationData);

      setState(() {
        location = locationData;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location updated successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update location: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(ImageAsset.map, height: 388, width: double.infinity),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: ElevatedButton(
                onPressed: () async {
                  await _uploadLocationToFirebase(); // Gọi hàm
                  Get.to(() => const MainNavView(initialIndex: 0));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffFF7622),
                  foregroundColor: const Color(0xFFFFFFFF),
                  minimumSize: const Size.fromHeight(62),
                ).copyWith(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'ACCESS LOCATION',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(width: 20),
                    SvgPicture.asset(ImageAsset.mapLocationWhite),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'DFOOD WILL ACCESS YOUR LOCATION',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'ONLY WHILE USING THE APP',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            FutureBuilder<String>(
              future: LocationService().getCurrentLocationAndAddress(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  location = snapshot.data!;
                  return Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(ImageAsset.marker,
                                height: 24, width: 24),
                            const SizedBox(width: 10),
                            const Text(
                              'Your Location',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                          ],
                        ),
                        Text(
                          location,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.blueAccent),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(
                      child: Text('No location data available.'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
