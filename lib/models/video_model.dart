class VideoModel {
  final String userUid;
  final String username;
  final String id;
  final String songName;
  final String caption;
  final String videoUrl;
  final String thumbnail;
  final List<Object?> likes;
  final int commentCount;
  final int shareCount;
  final String profilePhoto;

  const VideoModel({
    required this.userUid,
    required this.username,
    required this.id,
    required this.songName,
    required this.caption,
    required this.videoUrl,
    required this.thumbnail,
    required this.likes,
    required this.commentCount,
    required this.shareCount,
    required this.profilePhoto,
  });

  factory VideoModel.fromJson(Map<String, Object?> json) {
    final String userUid = json['userUid'] as String;
    final String username = json['username'] as String;
    final String id = json['id'] as String;
    final String songName = json['songName'] as String;
    final String caption = json['caption'] as String;
    final String videoUrl = json['videoUrl'] as String;
    final String thumbnail = json['thumbnail'] as String;
    final List<Object?> likes = json['likes'] as List<Object?>;
    final int commentCount = json['commentCount'] as int;
    final int shareCount = json['shareCount'] as int;
    final String profilePhoto = json['profilePhoto'] as String;

    return VideoModel(
      userUid: userUid,
      username: username,
      id: id,
      songName: songName,
      caption: caption,
      videoUrl: videoUrl,
      thumbnail: thumbnail,
      likes: likes,
      commentCount: commentCount,
      shareCount: shareCount,
      profilePhoto: profilePhoto,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'userUid': userUid,
      'username': username,
      'id': id,
      'songName': songName,
      'caption': caption,
      'videoUrl': videoUrl,
      'thumbnail': thumbnail,
      'likes': likes,
      'commentCount': commentCount,
      'shareCount': shareCount,
      'profilePhoto': profilePhoto,
    };
  }

  @override
  String toString() {
    return 'VideoModel{username: $username}';
  }
}
