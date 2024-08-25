import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/models/video_model.dart';
import 'package:tiktok_clone/services/constants/firebase.dart';
import 'package:video_compress/video_compress.dart';

class UploadVideoController extends GetxController {
  Future<File?> _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(
      videoPath,
      quality: VideoQuality.MediumQuality,
    );

    return compressedVideo!.file;
  }

  Future<String> _uploadImageToStorage(String id, String videoPath) async {
    final reference =
        CustomFirebase.firebaseStorage.ref().child('thumbnails').child(id);
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    final uploadTask = reference.putFile(thumbnail);
    final snapshot = await uploadTask;
    final downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    final reference =
        CustomFirebase.firebaseStorage.ref().child('videos').child(id);
    final uploadTask = reference.putFile((await _compressVideo(videoPath))!);
    final snapshot = await uploadTask;
    final downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  void uploadVideo({
    required String songName,
    required String caption,
    required String videoPath,
  }) async {
    try {
      final currentUserUid = CustomFirebase.firebaseAuth.currentUser!.uid;
      final userDocument = await CustomFirebase.firebaseFirestore
          .collection('users')
          .doc(currentUserUid)
          .get();

      debugPrint(currentUserUid);

      final allDocuments =
          await CustomFirebase.firebaseFirestore.collection('videos').get();
      int length = allDocuments.docs.length;

      final videoDownloadUrl =
          await _uploadVideoToStorage('Video $length', videoPath);
      final thumbnailDownloadUrl =
          await _uploadImageToStorage('Video $length', videoPath);

      final video = VideoModel(
        userUid: currentUserUid,
        username: (userDocument.data()! as Map<String, Object?>)['username']
            as String,
        id: 'Video $length',
        songName: songName,
        caption: caption,
        videoUrl: videoDownloadUrl,
        thumbnail: thumbnailDownloadUrl,
        likes: [],
        commentCount: 0,
        shareCount: 0,
        profilePhoto: (userDocument.data()!
            as Map<String, Object?>)['profilePhoto'] as String,
      );

      await CustomFirebase.firebaseFirestore
          .collection('videos')
          .doc('Video $length')
          .set(video.toJson());

      debugPrint('Upload Video Successful');
      Get.back();
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar('Error while uploading video to storage', e.toString());
    }
  }
}
