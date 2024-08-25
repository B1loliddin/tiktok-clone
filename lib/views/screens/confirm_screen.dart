import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controllers/upload_video_controller.dart';
import 'package:tiktok_clone/views/widgets/text_input_field.dart';
import 'package:video_player/video_player.dart';

class ConfirmScreen extends StatefulWidget {
  const ConfirmScreen({super.key});

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  late final VideoPlayerController _videoPlayerController;
  late final TextEditingController _songController;
  late final TextEditingController _captionController;
  late final UploadVideoController uploadVideoController;
  late final List<Object?> list;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    list = ModalRoute.of(context)!.settings.arguments as List;

    _initAllControllers(list[0] as File);
  }

  @override
  void dispose() {
    _disposeAllControllers();
    super.dispose();
  }

  void _initAllControllers(File video) {
    _songController = TextEditingController();
    _captionController = TextEditingController();
    uploadVideoController = Get.put(UploadVideoController());

    setState(() => _videoPlayerController = VideoPlayerController.file(video));

    _videoPlayerController.initialize();
    _videoPlayerController.play();
    _videoPlayerController.setVolume(1);
    _videoPlayerController.setLooping(true);
  }

  void _disposeAllControllers() {
    _videoPlayerController.dispose();
    _songController.dispose();
    _captionController.dispose();
    uploadVideoController.dispose();
  }

  void _uploadVideo() {
    uploadVideoController.uploadVideo(
      songName: _songController.text.trim(),
      caption: _captionController.text.trim(),
      videoPath: list[1] as String,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height / 1.5,
              child: VideoPlayer(_videoPlayerController),
            ),
            const SizedBox(height: 30),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    width: MediaQuery.sizeOf(context).width - 20,
                    child: TextInputField(
                      controller: _songController,
                      labelText: 'Song Name',
                      prefixIcon: const Icon(Icons.music_note),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    width: MediaQuery.sizeOf(context).width - 20,
                    child: TextInputField(
                      controller: _captionController,
                      labelText: 'Caption',
                      prefixIcon: const Icon(Icons.closed_caption),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _uploadVideo,
                    child: const Text(
                      'Share',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
