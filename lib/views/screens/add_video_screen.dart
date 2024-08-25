import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/services/constants/colors.dart';
import 'package:tiktok_clone/utils/helpers/show_snack_bar.dart';

class AddVideoScreen extends StatelessWidget {
  const AddVideoScreen({super.key});

  void _navigateToConfirmScreen(
          BuildContext context, List<Object?> arguments) =>
      Navigator.pushNamed(context, '/confirm_screen', arguments: arguments);

  void _pickVideo(BuildContext context, ImageSource source) async {
    final video = await ImagePicker().pickVideo(source: source);

    if (video != null) {
      if (context.mounted) {
        _navigateToConfirmScreen(
          context,
          [File(video.path), video.path],
        );
      }
    } else {
      if (context.mounted) showSnackBar(context, 'Choose a video');
    }
  }

  void _navigateToHomePage(BuildContext context) => Navigator.pop(context);

  void _showOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        children: [
          /// #gallery option
          SimpleDialogOption(
            onPressed: () => _pickVideo(context, ImageSource.gallery),
            child: const Row(
              children: [
                Icon(Icons.image),
                SizedBox(width: 10),
                Text(
                  'Gallery',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),

          /// #camera option
          SimpleDialogOption(
            onPressed: () => _pickVideo(context, ImageSource.camera),
            child: const Row(
              children: [
                Icon(Icons.camera_alt),
                SizedBox(width: 10),
                Text(
                  'Camera',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),

          /// #cancel option
          SimpleDialogOption(
            onPressed: () => _navigateToHomePage(context),
            child: const Row(
              children: [
                Icon(Icons.cancel),
                SizedBox(width: 10),
                Text(
                  'Cancel',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: CustomColors.buttonColor,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: GestureDetector(
            onTap: () => _showOptionsDialog(context),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              height: 50,
              child: const Center(
                child: Text(
                  'Add Video',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
