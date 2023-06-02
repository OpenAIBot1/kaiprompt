import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kaiprompt/models/user.dart';

class UserService {
  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection('Users');

  Future<UserModel> getUser(String userId) async {
    DocumentSnapshot doc = await _usersRef.doc(userId).get();
    return UserModel.fromDocumentSnapshot(doc);
  }

  Future<void> createUser(UserModel user) async {
    await _usersRef.doc(user.userId).set(user.toDocument());
  }

  Future<void> updateUser(UserModel user) async {
    await _usersRef.doc(user.userId).update(user.toDocument());
  }

  Future<void> deleteUser(String userId) async {
    await _usersRef.doc(userId).delete();
  }

  Future<void> upvotePrompt(String userId, String promptId) async {
    await _usersRef.doc(userId).update({
      'upvoted_prompts': FieldValue.arrayUnion([promptId])
    });
  }

  Future<void> downvotePrompt(String userId, String promptId) async {
    await _usersRef.doc(userId).update({
      'downvoted_prompts': FieldValue.arrayUnion([promptId])
    });
  }

  Future<void> removeUpvote(String userId, String promptId) async {
    await _usersRef.doc(userId).update({
      'upvoted_prompts': FieldValue.arrayRemove([promptId])
    });
  }

  Future<void> removeDownvote(String userId, String promptId) async {
    await _usersRef.doc(userId).update({
      'downvoted_prompts': FieldValue.arrayRemove([promptId])
    });
  }

  Future<void> addFavouritePrompt(String userId, String promptId) async {
    await _usersRef.doc(userId).update({
      'fav_prompts': FieldValue.arrayUnion([promptId])
    });
  }

  Future<void> removeFavouritePrompt(String userId, String promptId) async {
    await _usersRef.doc(userId).update({
      'fav_prompts': FieldValue.arrayRemove([promptId])
    });
  }

  Future<void> addCreatedPrompt(String userId, String promptId) async {
    await _usersRef.doc(userId).update({
      'created_prompts': FieldValue.arrayUnion([promptId])
    });
  }
}
