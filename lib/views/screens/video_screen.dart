import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controllers/video_controller.dart';
import 'package:tiktok_clone/models/video_model.dart';
import 'package:tiktok_clone/services/constants/colors.dart';
import 'package:tiktok_clone/services/constants/get_x.dart';
import 'package:tiktok_clone/views/widgets/circle_animation.dart';
import 'package:tiktok_clone/views/widgets/video_player_item.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late final VideoController _videoController;

  @override
  void initState() {
    super.initState();
    _initAllControllers();
  }

  @override
  void dispose() {
    _disposeAllControllers();
    super.dispose();
  }

  void _initAllControllers() {
    _videoController = Get.put(VideoController());
  }

  void _disposeAllControllers() {
    // _videoController.dispose();
  }

  void _likeVideo(String videoId) => _videoController.likeVideo(videoId);

  bool _isLikedVideo(VideoModel video) =>
      video.likes.contains(CustomGetX.authController.user.uid);

  void _navigateToCommentScreen(String videoId) =>
      Navigator.pushNamed(context, '/comment_screen', arguments: videoId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: _videoController.videoList.length,
            controller: PageController(initialPage: 0, viewportFraction: 1),
            itemBuilder: (context, index) {
              final video = _videoController.videoList[index];

              return Stack(
                children: [
                  /// #video
                  VideoPlayerItem(
                    videoUrl: video.videoUrl,
                  ),

                  /// #username, caption, song name
                  Positioned(
                    bottom: 20,
                    left: 18,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// #username
                        Text(
                          video.username,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: CustomColors.whiteColor,
                          ),
                        ),

                        /// #caption
                        Text(
                          video.caption,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: CustomColors.whiteColor,
                          ),
                        ),

                        /// #song name
                        Row(
                          children: [
                            /// #
                            const Icon(
                              Icons.music_note,
                              size: 16,
                              color: CustomColors.whiteColor,
                            ),

                            /// #song name
                            Text(
                              video.songName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: CustomColors.whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  /// #profile, like, comment, reply
                  Positioned(
                    bottom: 30,
                    right: 24,
                    child: Column(
                      children: [
                        /// #
                        Profile(profilePhoto: video.profilePhoto),

                        /// #like
                        Column(
                          children: [
                            IconButton(
                              iconSize: 40,
                              onPressed: () => _likeVideo(video.id),
                              icon: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (child, animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                                child: Icon(
                                  Icons.favorite,
                                  key: ValueKey<bool>(_isLikedVideo(video)),
                                  color: _isLikedVideo(video)
                                      ? CustomColors.buttonColor
                                      : CustomColors.whiteColor,
                                ),
                              ),
                            ),
                            Text(
                              video.likes.length.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                color: CustomColors.whiteColor,
                              ),
                            ),
                          ],
                        ),

                        /// #comment
                        Column(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.comment),
                              iconSize: 40,
                              onPressed: () =>
                                  _navigateToCommentScreen(video.id),
                              color: CustomColors.whiteColor,
                            ),
                            Text(
                              video.commentCount.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                color: CustomColors.whiteColor,
                              ),
                            ),
                          ],
                        ),

                        /// #reply
                        Column(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.reply),
                              iconSize: 40,
                              onPressed: () {},
                              color: CustomColors.whiteColor,
                            ),
                            Text(
                              video.shareCount.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                color: CustomColors.whiteColor,
                              ),
                            ),
                          ],
                        ),

                        CircleAnimation(
                          child: MusicAlbum(profilePhoto: video.profilePhoto),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class MusicAlbum extends StatelessWidget {
  final String profilePhoto;

  const MusicAlbum({super.key, required this.profilePhoto});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Column(
        children: [
          DecoratedBox(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              gradient: LinearGradient(
                colors: [
                  CustomColors.borderColor,
                  CustomColors.whiteColor,
                ],
              ),
            ),
            child: SizedBox(
              height: 35,
              width: 35,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                child: Image(
                  image: NetworkImage(profilePhoto),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Profile extends StatelessWidget {
  final String profilePhoto;

  const Profile({super.key, required this.profilePhoto});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        children: [
          Positioned(
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: CustomColors.whiteColor,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                child: Image(
                  image: NetworkImage(profilePhoto),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
