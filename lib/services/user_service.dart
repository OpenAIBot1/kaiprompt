import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kaiprompt/models/user.dart';

class UserService {
  final FirebaseFirestore _firestore;

  UserService(this._firestore);

  Future<UserModel> getUser(String userId) async {
    final userDoc = await _firestore.collection('Users').doc(userId).get();
    return UserModel.fromMap(userDoc.data()!);
  }

  Future<void> createUser(UserModel user) async {
    await _firestore.collection('Users').doc(user.userId).set(user.toMap());
  }

  Future<void> updateUser(UserModel user) async {
    await _firestore.collection('Users').doc(user.userId).update(user.toMap());
  }
}

final userServiceProvider = Provider<UserService>((ref) {
  final firestore = FirebaseFirestore.instance;
  return UserService(firestore);
});
