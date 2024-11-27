import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpViewModel extends GetxController {
  final FirebaseAuth _firAuth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final formKey = GlobalKey<FormState>();

  String? email;
  String? password;
  String? confirmPassword;
  String? hoTen;
  String? address;
  String? sex;
  String? numberPhone;


  RxBool isEntryPasswordObscured = true.obs;
  RxBool isObscured = true.obs;
  final showPassword = false.obs;
  final isLoading = false.obs;

  void toggleObscureText() {
    isObscured.value = !isObscured.value;
  }

  void showHidePassword() {
    showPassword.value = !showPassword.value;
  }

  void toggleEntryPasswordObscureText() {
    isEntryPasswordObscured.value = !isEntryPasswordObscured.value;
  }

  void onChangeUsername(String valueEmail) {
    email = valueEmail;
    formKey.currentState?.validate();
  }

  void onChangePassword(String valuePassword) {
    password = valuePassword;
    formKey.currentState?.validate();
  }

  void onChangeConfirmPassword(String valueconfirmPassword) {
    confirmPassword = valueconfirmPassword;
    formKey.currentState?.validate();
  }

  void onChangeCheckName(String valuehoTen) {
    hoTen = valuehoTen;
    formKey.currentState?.validate();
  }

  void onChangeCheckAdress(String valueaddress) {
    address = valueaddress;
    formKey.currentState?.validate();
  }

  void onChangeCheckSex(String valuesex) {
    sex = valuesex;
    formKey.currentState?.validate();
  }
  void onChangeCheckNumberPhone(String valueNumberPhone) {
    numberPhone = valueNumberPhone;
    formKey.currentState?.validate();
  }

  void signUp(
      String email,
      String passWord,
      String entryPassword,
      String hoTen,
      String addRess,
      String sex,
      String numberPhone,
      Function onSuccess,
      Function(String) onError) {
    _firAuth
        .createUserWithEmailAndPassword(email: email, password: passWord)
        .then((UserCredential userCredential) {
      // Đẩy dữ liệu người dùng lên Firebase Realtime Database
      _dbRef.child('users').child(userCredential.user!.uid).set({
        'email': email,
        'fullName': hoTen,
        'address': addRess,
        'sex': sex,
        'numberPhone': numberPhone,
        'role': 'user', // Thêm giá trị mặc định cho role
      }).then((_) {
        onSuccess();
      }).catchError((error) {
        onError('Failed to save user data: $error');
      });
    }).catchError((error) {
      onError('Failed to sign up: $error');
    });
  }


  bool containsSpecialCharacters(String text) {
    final allowedSpecialCharacters = RegExp(r'[!@#\$%^&*(),.?":{}|<>]');
    return allowedSpecialCharacters.hasMatch(text);
  }

  bool containsUppercaseLetter(String text) {
    return RegExp(r'[A-Z]').hasMatch(text);
  }

  bool containsLowercaseLetter(String text) {
    return RegExp(r'[a-z]').hasMatch(text);
  }

  bool containsDigit(String text) {
    return RegExp(r'\d').hasMatch(text);
  }

  String? validatorUsername(String? email) {
    if ((email ?? '').isEmpty) {
      return 'Email không được để trống';
    } else if ((email ?? '').length < 6) {
      return 'Email không được nhỏ hơn 6 ký tự';
    } else if (!containsSpecialCharacters(email!)) {
      return 'Email cần chứa ký tự đặc biệt';
    } else {
      return null;
    }
  }

  String? validatorPassword(String? value) {
    if ((value ?? '').isEmpty) {
      return 'Password không được để trống';
    } else if ((value ?? '').length < 6) {
      return 'Password không được nhỏ hơn 6 ký tự';
    } else if (value!.contains(' ')) {
      return 'Password không được chứa khoảng trắng';
    } else if (!containsUppercaseLetter(value)) {
      return 'Password cần chứa ít nhất 1 ký tự viết hoa';
    } else if (!containsLowercaseLetter(value)) {
      return 'Password cần chứa ít nhất 1 ký tự viết thường';
    } else if (!containsDigit(value)) {
      return 'Password cần chứa ít nhất 1 chữ số';
    } else if (!containsSpecialCharacters(value)) {
      return 'Password cần chứa ít nhất 1 ký tự đặc biệt';
    } else {
      return null;
    }
  }

  String? validatorConfirmPassword(String? value) {
    if (value != password) {
      return 'Password nhập lại không khớp';
    } else {
      return null;
    }
  }

  String? validatorCheck(String? value) {
    if ((value ?? '').isEmpty) {
      return 'Không được để trống';
    } else {
      return null;
    }
  }

  bool isValidSignupForm() {
    return formKey.currentState!.validate();
  }

  void resetForm() {
    email = null;
    password = null;
    confirmPassword = null;
    hoTen = null;
    address = null;
    sex = null;
    numberPhone = null;
    formKey.currentState?.reset();
  }
}
