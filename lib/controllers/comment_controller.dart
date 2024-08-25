import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/models/comment_model.dart';
import 'package:tiktok_clone/services/constants/firebase.dart';
import 'package:tiktok_clone/services/constants/get_x.dart';

class CommentController extends GetxController {
  final Rx<List<CommentModel>> _commentList = Rx<List<CommentModel>>([]);

  List<CommentModel> get commentList => _commentList.value;

  String _videoId = '';

  void updatePostId(String videoId) {
    _videoId = videoId;

    getCommentList();
  }

  void getCommentList() {
    _commentList.bindStream(
      CustomFirebase.firebaseFirestore
          .collection('videos')
          .doc(_videoId)
          .collection('comments')
          .snapshots()
          .map(
        (query) {
          final result = <CommentModel>[];

          for (final element in query.docs) {
            result.add(CommentModel.fromJson(element.data()));
          }

          return result;
        },
      ),
    );
  }

  void postComment(String commentText) async {
    try {
      final userDocument = await CustomFirebase.firebaseFirestore
          .collection('users')
          .doc(CustomGetX.authController.user.uid)
          .get();
      final allCommentsDocuments = await CustomFirebase.firebaseFirestore
          .collection('videos')
          .doc(_videoId)
          .collection('comments')
          .get();
      final length = allCommentsDocuments.docs.length;

      final comment = CommentModel(
        userUid: userDocument.data()!['uid'] as String,
        username: userDocument.data()!['username'] as String,
        id: 'Comment $length',
        comment: commentText,
        publishDate: DateTime.now(),
        likes: [],
        profilePhoto: userDocument.data()!['profilePhoto'] as String,
      );

      await CustomFirebase.firebaseFirestore
          .collection('videos')
          .doc(_videoId)
          .collection('comments')
          .doc('Comment $length')
          .set(comment.toJson());

      final videosDocument = await CustomFirebase.firebaseFirestore
          .collection('videos')
          .doc(_videoId)
          .get();

      CustomFirebase.firebaseFirestore
          .collection('videos')
          .doc(_videoId)
          .update(
        {
          'commentCount': (videosDocument.data()!['commentCount'] as int) + 1,
        },
      );
    } catch (e) {
      Get.snackbar('Error while posting a comment', e.toString());
      debugPrint(e.toString());
    }
  }

  void likeComment(String commentId) async {
    final userUid = CustomGetX.authController.user.uid;

    final commentDocument = await CustomFirebase.firebaseFirestore
        .collection('videos')
        .doc(_videoId)
        .collection('comments')
        .doc(commentId)
        .get();
    if ((commentDocument.data()!['likes'] as List<Object?>).contains(userUid)) {
      await CustomFirebase.firebaseFirestore
          .collection('videos')
          .doc(_videoId)
          .collection('comments')
          .doc(commentId)
          .update({
        'likes': FieldValue.arrayRemove([userUid])
      });
    } else {
      await CustomFirebase.firebaseFirestore
          .collection('videos')
          .doc(_videoId)
          .collection('comments')
          .doc(commentId)
          .update({
        'likes': FieldValue.arrayUnion([userUid])
      });
    }
  }
}
