class UserModel {
  final String uid;
  final String username;
  final String email;
  final String profilePhoto;

  const UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.profilePhoto,
  });

  factory UserModel.fromJson(Map<String, Object?> json) {
    final String uid = json['uid'] as String;
    final String username = json['username'] as String;
    final String email = json['email'] as String;
    final String profilePhoto = json['profilePhoto'] as String;

    return UserModel(
      uid: uid,
      username: username,
      email: email,
      profilePhoto: profilePhoto,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'profilePhoto': profilePhoto,
    };
  }

  @override
  String toString() {
    return 'UserModel{username: $username}';
  }
}
