import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 회원가입 시 사용자 정보 저장
  Future<void> createUser(String uid, String email, String nickname) async {
    await _db.collection('users').doc(uid).set({
      'email': email,
      'nickname': nickname,
    });
  }

  // 사용자 정보 가져오기
  Future<UserModel?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.id, doc.data()!);
    }
    return null;
  }

  // 주변 사용자 목록 가져오기
  Stream<List<UserModel>> getNearbyUsers() {
    return _db.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return UserModel.fromMap(doc.id, doc.data());
      }).toList();
    });
  }
} 