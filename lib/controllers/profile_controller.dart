import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/services/constants/firebase.dart';
import 'package:tiktok_clone/services/constants/get_x.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, Object?>> _user = Rx<Map<String, Object?>>({});

  Map<String, Object?> get user => _user.value;

  final Rx<String> _uid = ''.obs;

  String get uid => _uid.value;

  void updateUserId(String uid) async {
    _uid.value = uid;

    getUser();
  }

  void getUser() async {
    final thumbnails = <String>[];

    final currentUserVideos = await CustomFirebase.firebaseFirestore
        .collection('videos')
        .where('uid', isEqualTo: uid)
        .get();
    for (final element in currentUserVideos.docs) {
      thumbnails.add(element.data()['thumbnail'] as String);
    }

    final currentUserDocument = await CustomFirebase.firebaseFirestore
        .collection('users')
        .doc(uid)
        .get();

    debugPrint(currentUserDocument.data().toString());

    final currentUserData = currentUserDocument.data() as Map<String, Object?>;
    final username = currentUserData['username'];
    final profilePhoto = currentUserData['profilePhoto'];
    int likes = 0;
    int followers = 0;
    int followings = 0;
    bool isFollowing = false;

    for (final element in currentUserVideos.docs) {
      likes += (element.data()['likes'] as List).length;
    }

    final followersDocument = await CustomFirebase.firebaseFirestore
        .collection('users')
        .doc(uid)
        .collection('followers')
        .get();
    final followingsDocument = await CustomFirebase.firebaseFirestore
        .collection('users')
        .doc(uid)
        .collection('followings')
        .get();

    followers = followersDocument.docs.length;
    followings = followingsDocument.docs.length;

    CustomFirebase.firebaseFirestore
        .collection('users')
        .doc(uid)
        .collection('followers')
        .doc(CustomGetX.authController.user.uid)
        .get()
        .then(
          (value) => value.exists ? isFollowing = true : isFollowing = false,
        );

    _user.value = {
      'username': username,
      'profilePhoto': profilePhoto,
      'thumbnails': thumbnails,
      'likes': likes.toString(),
      'followers': followers.toString(),
      'followings': followings.toString(),
      'isFollowing': isFollowing,
    };

    update();
  }

  void followToUser() async {
    var doc = await CustomFirebase.firebaseFirestore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .doc(CustomGetX.authController.user.uid)
        .get();

    if (!doc.exists) {
      await CustomFirebase.firebaseFirestore
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(CustomGetX.authController.user.uid)
          .set({});

      await CustomFirebase.firebaseFirestore
          .collection('users')
          .doc(CustomGetX.authController.user.uid)
          .collection('following')
          .doc(_uid.value)
          .set({});

      _user.value.update(
        'followers',
        (value) => (int.parse(value as String) + 1).toString(),
      );
    } else {
      await CustomFirebase.firebaseFirestore
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(CustomGetX.authController.user.uid)
          .delete();

      await CustomFirebase.firebaseFirestore
          .collection('users')
          .doc(CustomGetX.authController.user.uid)
          .collection('following')
          .doc(_uid.value)
          .delete();

      _user.value.update(
        'followers',
        (value) => (int.parse(value as String) - 1).toString(),
      );
    }

    _user.value.update('isFollowing', (value) => !(value as bool));

    update();
  }
}
