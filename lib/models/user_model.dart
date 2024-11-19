class UserModel {
  final String id;        // Firebase Auth UID
  final String email;     // 이메일
  final String nickname;  // 닉네임

  UserModel({
    required this.id,
    required this.email,
    required this.nickname,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'nickname': nickname,
    };
  }

  factory UserModel.fromMap(String id, Map<String, dynamic> map) {
    return UserModel(
      id: id,
      email: map['email'] ?? '',
      nickname: map['nickname'] ?? '',
    );
  }
} 