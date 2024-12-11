// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomeViewModel extends GetxController {
  late TextEditingController searchController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final _database = FirebaseDatabase.instance.ref();
  final _userData = {}.obs;
  String _userId = '';
  late stt.SpeechToText _speech;
  bool isListening = false;
  RxMap get userData => _userData;

  @override
  void onInit() {
    super.onInit();
    _initializeUserId();
    initializeSpeechToText();
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

  void initializeSpeechToText() async {
    _speech = stt.SpeechToText();
    bool available = await _speech.initialize();
    if (!available) {
      print('Speech recognition not available');
    }
  }

  void toggleListening() async {
    if (!isListening) {
      isListening = true;
      await _speech.listen(onResult: (result) {
        searchController.text = result.recognizedWords;
      });
    } else {
      isListening = false;
      await _speech.stop();
    }
    update();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
