import 'package:flutter/material.dart';
import 'package:flutter_hungry_hub/view_model/profile_view_model.dart';
import 'package:flutter_hungry_hub/widgets/common_widget/profile/app_bar_profile.dart';
import 'package:get/get.dart';

class Addresses extends StatelessWidget {
  const Addresses({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileViewModel());
    final String location = controller.userData['location'] ?? "Not Available";
    final String address = controller.userData['address'] ?? "No Address Found";

    return Scaffold(
      appBar: AppBarProfile(title: 'Addresses'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card to display address information
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Location information
                    ListTile(
                      leading: Icon(Icons.location_on, color: Colors.redAccent),
                      title: Text(
                        'Location',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                      subtitle: Text(
                        location,
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ),
                    Divider(),
                    // Address information
                    ListTile(
                      leading: Icon(Icons.home, color: Colors.blueAccent),
                      title: Text(
                        'Address',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                      subtitle: Text(
                        address,
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add address action
          print("Add new address");
        },
        backgroundColor: Color(0xffEF5350),
        child: Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
