import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controllers/profile_controller.dart';
import 'package:tiktok_clone/services/constants/get_x.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileController _profileController;
  String? _userUid;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _userUid = ModalRoute.settingsOf(context)?.arguments as String?;
    debugPrint(_userUid.toString());

    _initAllControllers();
    _profileController.updateUserId(
      _userUid ?? CustomGetX.authController.user.uid,
    );
  }

  @override
  void dispose() {
    _disposeAllControllers();
    super.dispose();
  }

  void _initAllControllers() {
    _profileController = Get.put(ProfileController());
  }

  void _disposeAllControllers() {
    // _profileController.dispose();
  }

  void _signOut() => CustomGetX.authController.signOut();

  void _followToUser() => _profileController.followToUser();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controller) {
        if (controller.user.isEmpty) {
          return const CircularProgressIndicator.adaptive();
        }

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.person_add),
            ),
            title: Text(
              _profileController.user['username'].toString(),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_horiz),
              )
            ],
          ),
          body: Column(
            children: [
              const SizedBox(height: 20),

              /// #
              CircleAvatar(
                radius: 55,
                backgroundImage: NetworkImage(
                  _profileController.user['profilePhoto'].toString(),
                ),
              ),
              const SizedBox(height: 30),

              /// #followings, likes, followers
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        _profileController.user['followings'].toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Text(
                        'Following',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        _profileController.user['likes'].toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Text(
                        'Likes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        _profileController.user['followers'].toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Text(
                        'Followers',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),

              /// #sign out button
              ElevatedButton(
                onPressed: _userUid == CustomGetX.authController.user.uid ||
                        _userUid == null
                    ? _signOut
                    : _followToUser,
                child: Text(
                  _userUid == CustomGetX.authController.user.uid ||
                          _userUid == null
                      ? 'Sign Out'
                      : controller.user['isFollowing'] as bool
                          ? 'Unfollow'
                          : 'Follow',
                ),
              ),

              // video list
              SizedBox(
                width: 400,
                height: 100,
                child: GridView.builder(
                  
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: (controller.user['thumbnails'] as List).length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    crossAxisSpacing: 5,
                  ),
                  itemBuilder: (context, index) {
                    debugPrint(controller.user['thumbnails'].toString());

                    String thumbnail =
                        (controller.user['thumbnails'] as List)[index];
                
                    return Image(
                      image: NetworkImage(thumbnail),
                      fit: BoxFit.cover,
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
