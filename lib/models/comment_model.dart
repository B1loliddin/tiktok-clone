class CommentModel {
  final String userUid;
  final String username;
  final String id;
  final String comment;
  final DateTime publishDate;
  final List<Object?> likes;
  final String profilePhoto;

  CommentModel({
    required this.userUid,
    required this.username,
    required this.id,
    required this.comment,
    required this.publishDate,
    required this.likes,
    required this.profilePhoto,
  });

  factory CommentModel.fromJson(Map<String, Object?> json) {
    final String userUid = json['userUid'] as String;
    final String username = json['username'] as String;
    final String id = json['id'] as String;
    final String comment = json['comment'] as String;
    final DateTime publishDate = DateTime.parse(json['publishDate'] as String);
    final List<Object?> likes = json['likes'] as List<Object?>;
    final String profilePhoto = json['profilePhoto'] as String;

    return CommentModel(
        userUid: userUid,
        username: username,
        id: id,
        comment: comment,
        publishDate: publishDate,
        likes: likes,
        profilePhoto: profilePhoto);
  }

  Map<String, Object?> toJson() {
    return {
      'userUid': userUid,
      'username': username,
      'id': id,
      'comment': comment,
      'publishDate': publishDate.toIso8601String(),
      'likes': likes,
      'profilePhoto': profilePhoto,
    };
  }
}
