import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/models/user_model.dart';
import 'package:tiktok_clone/services/constants/firebase.dart';

class SearchController extends GetxController {
  final Rx<List<UserModel>> _searchedUsers = Rx<List<UserModel>>([]);

  List<UserModel> get searchedUsers => _searchedUsers.value;

  void searchUsers(String searchingUser) {
    _searchedUsers.bindStream(
      CustomFirebase.firebaseFirestore
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: searchingUser)
          .snapshots()
          .map(
        (query) {
          final result = <UserModel>[];

          for (final element in query.docs) {
            result.add(UserModel.fromJson(element.data()));
            debugPrint(UserModel.fromJson(element.data()).username);
          }

          return result;
        },
      ),
    );
  }
}
