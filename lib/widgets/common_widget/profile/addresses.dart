import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hungry_hub/view_model/profile_view_model.dart';
import 'package:flutter_hungry_hub/widgets/common_widget/profile/app_bar_profile.dart';
import 'package:get/get.dart';

import '../button/bassic_button.dart';

class Addresses extends StatefulWidget {
  const Addresses({super.key});

  @override
  State<Addresses> createState() => _AddressesState();
}

class _AddressesState extends State<Addresses> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  Map<String, String> _addresses = {}; // Variable to hold the addresses

  Future<Map<String, String>> _fetchLocationsFromFirebase() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        throw Exception("No user is signed in.");
      }

      String userId = currentUser.uid;
      DataSnapshot snapshot = await _database.child('users/$userId/AddAdress').get();

      if (snapshot.exists && snapshot.value is Map) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        return data.map((key, value) => MapEntry(key.toString(), value.toString()));
      }
    } catch (e) {
      debugPrint("Error fetching locations: $e");
    }

    return {};
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileViewModel());
    final String address = controller.userData['address'] ?? "No Address Found";

    return Scaffold(
      appBar: AppBarProfile(title: 'Addresses'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.home, color: Colors.blueAccent),
                      title: Text(
                        'Primary Address',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54, fontFamily: 'Poppins'),
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
            FutureBuilder<Map<String, String>>(
              future: _fetchLocationsFromFirebase(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  _addresses = snapshot.data!; // Update the local _addresses map
                  if (_addresses.isEmpty) {
                    return const Center(child: Text('No addresses found.'));
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: _addresses.length,
                      itemBuilder: (context, index) {
                        String key = _addresses.keys.elementAt(index);
                        String value = _addresses[key]!;
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: const Icon(Icons.location_on, color: Colors.green),
                            title: Text(key, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(value),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _deleteAddressFromFirebase(key); // Gọi hàm xóa
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(child: Text('No data available.'));
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddAddressModal(context);
        },
        backgroundColor: Color(0xffEF5350),
        child: Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _showAddAddressModal(BuildContext context) {
    TextEditingController nameAddressController = TextEditingController();
    TextEditingController addressController = TextEditingController();

    showModalBottomSheet(
      context: context,
      barrierColor: Colors.grey.withOpacity(0.8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isDismissible: true,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.6,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Add Address',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: nameAddressController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xff979797).withOpacity(0.1),
                      label: const Text('Address Name'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: addressController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xff979797).withOpacity(0.1),
                      label: const Text('Address'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  BasicAppButton(
                    onPressed: () {
                      _uploadAddressToFirebase(nameAddressController, addressController);
                      setState(() {
                        _addresses[nameAddressController.text.trim()] = addressController.text.trim(); // Add the new address to the local state
                      });
                    },
                    title: 'Add',
                    sizeTitle: 16,
                    fontW: FontWeight.w500,
                    colorButton: const Color(0xffE03137),
                    height: 50,
                    radius: 8,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _uploadAddressToFirebase(TextEditingController nameAddressController, TextEditingController addressController) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        throw Exception("No user is signed in.");
      }

      String userId = currentUser.uid;
      String nameAddress = nameAddressController.text.trim();
      String address = addressController.text.trim();

      if (nameAddress.isEmpty || address.isEmpty) {
        throw Exception("Both fields are required.");
      }

      await _database.child('users/$userId/AddAdress/$nameAddress').set(address);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Address added successfully!")));

      nameAddressController.clear();
      addressController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to add address: $e")));
    }
  }

  Future<void> _deleteAddressFromFirebase(String addressName) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        throw Exception("No user is signed in.");
      }

      String userId = currentUser.uid;

      // Xóa địa chỉ từ Firebase
      await _database.child('users/$userId/AddAdress/$addressName').remove();

      setState(() {
        _addresses.remove(addressName); // Remove the address from the local state
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Address deleted successfully!")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to delete address: $e")));
    }
  }
}
