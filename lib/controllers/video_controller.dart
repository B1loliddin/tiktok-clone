import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/models/video_model.dart';
import 'package:tiktok_clone/services/constants/firebase.dart';
import 'package:tiktok_clone/services/constants/get_x.dart';

class VideoController extends GetxController {
  final Rx<List<VideoModel>> _videoList = Rx<List<VideoModel>>([]);

  List<VideoModel> get videoList => _videoList.value;

  @override
  void onInit() {
    super.onInit();

    _videoList.bindStream(
      CustomFirebase.firebaseFirestore.collection('videos').snapshots().map(
        (query) {
          List<VideoModel> result = [];

          for (final element in query.docs) {
            result.add(VideoModel.fromJson(element.data()));
          }

          return result;
        },
      ),
    );
  }

  void likeVideo(String videoId) async {
    try {
      final document = await CustomFirebase.firebaseFirestore
          .collection('videos')
          .doc(videoId)
          .get();
      final userUid = CustomGetX.authController.user.uid;

      if ((document.data()!['likes'] as List).contains(userUid)) {
        await CustomFirebase.firebaseFirestore
            .collection('videos')
            .doc(videoId)
            .update({
          'likes': FieldValue.arrayRemove([userUid]),
        });
      } else {
        await CustomFirebase.firebaseFirestore
            .collection('videos')
            .doc(videoId)
            .update({
          'likes': FieldValue.arrayUnion([userUid]),
        });
      }
    } catch (e) {
      Get.snackbar('Error while liking a video', e.toString());
      debugPrint(e.toString());
    }
  }
}
