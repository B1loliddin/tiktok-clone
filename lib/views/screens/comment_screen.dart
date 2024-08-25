import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controllers/comment_controller.dart';
import 'package:tiktok_clone/models/comment_model.dart';
import 'package:tiktok_clone/services/constants/colors.dart';
import 'package:tiktok_clone/services/constants/get_x.dart';
import 'package:tiktok_clone/utils/helpers/show_snack_bar.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _commentTextController;
  late final CommentController _commentController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final id = ModalRoute.settingsOf(context)!.arguments as String;

    _initAllControllers();
    _commentController.updatePostId(id);
  }

  @override
  void dispose() {
    _disposeAllControllers();
    super.dispose();
  }

  void _initAllControllers() {
    _commentTextController = TextEditingController();
    _commentController = Get.put(CommentController());
  }

  void _disposeAllControllers() {
    _commentTextController.dispose();
    _commentController.dispose();
  }

  void _writeComment() {
    if (_formKey.currentState!.validate()) {
      _commentController.postComment(_commentTextController.text.trim());
      _commentTextController.clear();
    } else {
      showSnackBar(context, 'Write your comment');
    }
  }

  bool _isLikedComment(CommentModel comment) =>
      comment.likes.contains(CustomGetX.authController.user.uid);

  void _likeComment(String commentId) =>
      _commentController.likeComment(commentId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: Stack(
        children: [
          /// #comments
          Obx(
            () {
              return Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: ListView.builder(
                  itemCount: _commentController.commentList.length,
                  itemBuilder: (context, index) {
                    final comment = _commentController.commentList[index];

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: CustomColors.backgroundColor,
                        backgroundImage: NetworkImage(comment.profilePhoto),
                      ),
                      title: Row(
                        children: [
                          /// #username
                          Text(
                            comment.username,
                            style: TextStyle(
                              fontSize: 20,
                              color: CustomColors.buttonColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),

                          /// #actual comment
                          Expanded(
                            child: Text(
                              comment.comment,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          /// #post date time
                          Text(
                            '${DateTime.now().day - comment.publishDate.day} days ago',
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 10),

                          /// #number of likes
                          Text(
                            '${comment.likes.length.toString()} likes',
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                      /// #like button
                      trailing: IconButton(
                        onPressed: () => _likeComment(comment.id),
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
                            key: ValueKey<bool>(_isLikedComment(comment)),
                            color: _isLikedComment(comment)
                                ? CustomColors.buttonColor
                                : CustomColors.whiteColor,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),

          /// #background color for text field
          Align(
            alignment: Alignment.bottomCenter,
            child: DecoratedBox(
              decoration: const BoxDecoration(color: CustomColors.backgroundColor),
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: 90,
              ),
            ),
          ),

          /// #comment text field
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Form(
                key: _formKey,
                child: ListTile(
                  title: TextFormField(
                    controller: _commentTextController,
                    style: const TextStyle(
                      fontSize: 16,
                      color: CustomColors.whiteColor,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Comment',
                      labelStyle: const TextStyle(
                        fontSize: 20,
                        color: CustomColors.whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.buttonColor),
                      ),
                    ),
                  ),
                  trailing: TextButton(
                    onPressed: _writeComment,
                    child: const Text('Send'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
