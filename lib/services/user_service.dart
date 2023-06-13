import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kaiprompt/models/user.dart';
import 'package:kaiprompt/utils/logger.dart';
import 'package:kaiprompt/utils/service_response.dart';

class UserService {
  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection('users');

  Future<ServiceResponse<UserModel>> getUser(String userId) async {
    try {
      DocumentSnapshot doc = await _usersRef.doc(userId).get();
      if (doc.exists) {
        return ServiceResponse(data: UserModel.fromDocumentSnapshot(doc));
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      logger.e('Failed to get user: $e');
      return ServiceResponse(error: 'Failed to get user: $e');
    }
  }

  Future<ServiceResponse<void>> createUser(UserModel user) async {
    try {
      await _usersRef.doc(user.userId).set(user.toDocument());
      return ServiceResponse(data: null);
    } catch (e) {
      logger.e('Failed to create user: $e');
      return ServiceResponse(error: 'Failed to create user: $e');
    }
  }

  Future<ServiceResponse<void>> updateUser(UserModel user) async {
    try {
      await _usersRef.doc(user.userId).update(user.toDocument());
      return ServiceResponse(data: null);
    } catch (e) {
      logger.e('Failed to update user: $e');
      return ServiceResponse(error: 'Failed to update user: $e');
    }
  }

  Future<ServiceResponse<void>> deleteUser(String userId) async {
    try {
      await _usersRef.doc(userId).delete();
      return ServiceResponse(data: null);
    } catch (e) {
      logger.e('Failed to delete user: $e');
      return ServiceResponse(error: 'Failed to delete user: $e');
    }
  }

  Future<ServiceResponse<void>> upvotePrompt(
      String userId, String promptId) async {
    try {
      await _usersRef.doc(userId).update({
        'upvoted_prompts': FieldValue.arrayUnion([promptId])
      });
      return ServiceResponse<void>(data: null);
    } catch (e) {
      logger.e('Failed to upvote prompt: $e');
      return ServiceResponse<void>(error: 'Failed to upvote prompt: $e');
    }
  }

  Future<ServiceResponse<void>> downvotePrompt(
      String userId, String promptId) async {
    try {
      await _usersRef.doc(userId).update({
        'downvoted_prompts': FieldValue.arrayUnion([promptId])
      });
      return ServiceResponse<void>(data: null);
    } catch (e) {
      logger.e('Failed to downvote prompt: $e');
      return ServiceResponse<void>(error: 'Failed to downvote prompt: $e');
    }
  }

  Future<ServiceResponse<void>> removeUpvote(
      String userId, String promptId) async {
    try {
      await _usersRef.doc(userId).update({
        'upvoted_prompts': FieldValue.arrayRemove([promptId])
      });
      return ServiceResponse<void>(data: null);
    } catch (e) {
      logger.e('Failed to remove upvote: $e');
      return ServiceResponse<void>(error: 'Failed to remove upvote: $e');
    }
  }

  Future<ServiceResponse<void>> removeDownvote(
      String userId, String promptId) async {
    try {
      await _usersRef.doc(userId).update({
        'downvoted_prompts': FieldValue.arrayRemove([promptId])
      });
      return ServiceResponse<void>(data: null);
    } catch (e) {
      logger.e('Failed to remove downvote: $e');
      return ServiceResponse<void>(error: 'Failed to remove downvote: $e');
    }
  }

  Future<ServiceResponse<void>> addFavouritePrompt(
      String userId, String promptId) async {
    try {
      await _usersRef.doc(userId).update({
        'fav_prompts': FieldValue.arrayUnion([promptId])
      });
      return ServiceResponse<void>(data: null);
    } catch (e) {
      logger.e('Failed to add favourite prompt: $e');
      return ServiceResponse<void>(error: 'Failed to add favourite prompt: $e');
    }
  }

  Future<ServiceResponse<void>> removeFavouritePrompt(
      String userId, String promptId) async {
    try {
      await _usersRef.doc(userId).update({
        'fav_prompts': FieldValue.arrayRemove([promptId])
      });
      return ServiceResponse<void>(data: null);
    } catch (e) {
      logger.e('Failed to remove favourite prompt: $e');
      return ServiceResponse<void>(
          error: 'Failed to remove favourite prompt: $e');
    }
  }

  Future<ServiceResponse<void>> addCreatedPrompt(
      String userId, String promptId) async {
    try {
      await _usersRef.doc(userId).update({
        'created_prompts': FieldValue.arrayUnion([promptId])
      });
      return ServiceResponse<void>(data: null);
    } catch (e) {
      logger.e('Failed to add created prompt: $e');
      return ServiceResponse<void>(
          error: 'Failed to remove favourite prompt: $e');
    }
  }
}
