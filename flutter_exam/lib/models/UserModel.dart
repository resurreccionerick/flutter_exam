class UserModel {
  final String userId;
  final String userName;
  final String loginStatus;
  final String profilePicture;

  UserModel({
    required this.userId,
    required this.userName,
    required this.loginStatus,
    required this.profilePicture,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      userName: json['userName'],
      loginStatus: json['loginStatus'],
      profilePicture: json['profilePicture'],
    );
  }
}