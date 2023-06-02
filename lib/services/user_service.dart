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

  Future<void> deleteUser(String userId) async {
    await _firestore.collection('Users').doc(userId).delete();
  }

  Future<void> upvotePrompt(String userId, String promptId) async {
    await _firestore.collection('Users').doc(userId).update({
      'upvoted_prompts.$promptId': Timestamp.now(),
    });
  }

  Future<void> downvotePrompt(String userId, String promptId) async {
    await _firestore.collection('Users').doc(userId).update({
      'downvoted_prompts.$promptId': Timestamp.now(),
    });
  }

  Future<void> removeUpvote(String userId, String promptId) async {
    await _firestore.collection('Users').doc(userId).update({
      'upvoted_prompts.$promptId': FieldValue.delete(),
    });
  }

  Future<void> removeDownvote(String userId, String promptId) async {
    await _firestore.collection('Users').doc(userId).update({
      'downvoted_prompts.$promptId': FieldValue.delete(),
    });
  }

  Future<void> addFavouritePrompt(String userId, String promptId) async {
    await _firestore.collection('Users').doc(userId).update({
      'fav_prompts': FieldValue.arrayUnion([promptId]),
    });
  }

  Future<void> removeFavouritePrompt(String userId, String promptId) async {
    await _firestore.collection('Users').doc(userId).update({
      'fav_prompts': FieldValue.arrayRemove([promptId]),
    });
  }

  Future<void> addCreatedPrompt(String userId, String promptId) async {
    await _firestore.collection('Users').doc(userId).update({
      'created_prompts': FieldValue.arrayUnion([promptId]),
    });
  }
}

final userServiceProvider = Provider<UserService>((ref) {
  final firestore = FirebaseFirestore.instance;
  return UserService(firestore);
});
