import 'package:flutter/material.dart';
import 'package:tiktok_clone/services/constants/colors.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerItem({super.key, required this.videoUrl});

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late final VideoPlayerController _videoPlayerController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initAllControllers(widget.videoUrl);
  }

  @override
  void dispose() {
    _disposeAllControllers();
    super.dispose();
  }

  void _initAllControllers(String videoUrl) async {
    _videoPlayerController = VideoPlayerController.network(videoUrl);

    await _videoPlayerController.initialize();

    _videoPlayerController.play();
    _videoPlayerController.setVolume(1);
  }

  void _disposeAllControllers() {
    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return DecoratedBox(
      decoration: const BoxDecoration(color: CustomColors.backgroundColor),
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: VideoPlayer(_videoPlayerController),
      ),
    );
  }
}
