import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../model/firebase/firebase_authencation.dart';

class ProfileViewModel extends GetxController{
  late TextEditingController searchController = TextEditingController();
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final _userData = {}.obs;
  String _userId = '';
  RxMap get userData => _userData;

  @override
  void onInit() {
    super.onInit();
    _initializeUserId();
  }

  void _initializeUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.uid;
      await _getUserData();
    }
  }
  Future<void> _getUserData() async {
    DatabaseReference userRef = _database.child('users/$_userId');
    DataSnapshot snapshot = await userRef.get();

    if (snapshot.exists) {
      _userData.value = Map<String, dynamic>.from(snapshot.value as Map);
    } else {
      _userData.value = {};
    }
  }
  void onLogout() {
    FirAuth firAuth = FirAuth(); // Tạo một thể hiện của FirAuth
    firAuth.signOut(); // Gọi phương thức signOut từ thể hiện
  }
  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}