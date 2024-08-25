import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/models/user_model.dart';
import 'package:tiktok_clone/services/constants/firebase.dart';
import 'package:tiktok_clone/views/screens/auth/sign_in_screen.dart';
import 'package:tiktok_clone/views/screens/home_screen.dart';

class AuthController extends GetxController {
  static final instance = Get.find<AuthController>();

  late final Rx<File?> _pickedImage;
  late final Rx<User?> _user;

  File? get profilePhoto => _pickedImage.value;

  User get user => _user.value!;

  @override
  void onReady() {
    super.onReady();

    _user = Rx(CustomFirebase.firebaseAuth.currentUser);
    _user.bindStream(CustomFirebase.firebaseAuth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  void _setInitialScreen(User? user) {
    if (user == null) {
      debugPrint(user.toString());
      Get.offAll(() => const SignInScreen());
    } else {
      Get.offAll(() => const HomeScreen());
    }
  }

  void pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);

    if (pickedImage != null) {
      _pickedImage = Rx<File>(File(pickedImage.path));
      Get.snackbar('Profile photo', 'You have selected your profile photo');
    }
  }

  Future<String> _uploadFileToFirebaseStorage(File image) async {
    final currentUser = CustomFirebase.firebaseAuth.currentUser;

    final reference = CustomFirebase.firebaseStorage
        .ref()
        .child('profilePhotos')
        .child(currentUser!.uid);

    final uploadTask = reference.putFile(image);
    final snapshot = await uploadTask;
    final downloadUrl = snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  void signUp({
    required String username,
    required String email,
    required String password,
    required File profilePhoto,
  }) async {
    try {
      final userCredential =
          await CustomFirebase.firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String downloadUrl = await _uploadFileToFirebaseStorage(profilePhoto);

      final user = UserModel(
        uid: userCredential.user!.uid,
        username: username,
        email: email,
        profilePhoto: downloadUrl,
      );

      CustomFirebase.firebaseFirestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(user.toJson());

      debugPrint('Sign Up Successful');
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar('Sign up error', e.toString());
    }
  }

  void signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential =
          await CustomFirebase.firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      debugPrint('Sign In Successful');
      debugPrint(userCredential.toString());
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar('Sign In error', e.toString());
    }
  }

  void signOut() async => await CustomFirebase.firebaseAuth.signOut();
}
