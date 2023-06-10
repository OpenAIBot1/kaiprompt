import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:kaiprompt/models/prompt.dart';

final logger = Logger();
final _firestore = FirebaseFirestore.instance;
final _promptsCollection = _firestore.collection('prompts');
final _usersCollection = _firestore.collection('users');
final _versionsCollection = _firestore.collection('versions');

final promptServiceProvider =
    StateNotifierProvider<PromptService, PromptModel?>(
        (ref) => PromptService(FirebaseAuth.instance));

class PromptService extends StateNotifier<PromptModel?> {
  final FirebaseAuth _firebaseAuth;

  PromptService(this._firebaseAuth) : super(null);

  PromptModel? getCurrentPrompt() {
    // Get the current prompt
    return state;
  }

  Future<bool> createPrompt(String title,
      {bool isRemixing = false, String? basePrompt}) async {
    try {
      // Create a new prompt
      String promptId = _promptsCollection.doc().id;
      String? userId = _firebaseAuth.currentUser?.uid;

      // Add newly created prompt to the created_prompts of the user
      await _usersCollection.doc(userId).update({
        'created_prompts': FieldValue.arrayUnion([promptId])
      });

      Map<String, dynamic> promptData = {
        'prompt_id': promptId,
        'title': title,
        'tags': [],
        'is_published': false,
        'created_by': userId,
        'created_at': FieldValue.serverTimestamp(),
        'versions': [],
        'upvotes': {},
        'downvotes': {},
        'favs': {}
      };

      if (isRemixing && basePrompt != null) {
        promptData['base_prompt'] = basePrompt;

        // Add new promptId to the remixes field of prompt with id basePrompt
        await _promptsCollection.doc(basePrompt).update({
          'remixes': FieldValue.arrayUnion([promptId])
        });
      }

      await _promptsCollection.doc(promptId).set(promptData);
      return true;
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  Future<bool> editPrompt(
      String promptId, String title, List<String> tags) async {
    try {
      // Edit an existing prompt
      await _promptsCollection
          .doc(promptId)
          .update({'title': title, 'tags': tags});
      return true;
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  Future<bool> publishPrompt(String promptId) async {
    try {
      String? userId = _firebaseAuth.currentUser?.uid;
      DocumentSnapshot promptSnapshot =
          await _promptsCollection.doc(promptId).get();
      Map<String, dynamic>? promptData =
          promptSnapshot.data() as Map<String, dynamic>?;

      if (promptData != null && promptData['created_by'] == userId) {
        await _promptsCollection.doc(promptId).update({'is_published': true});
        return true;
      } else {
        return false; // Not the creator of the prompt
      }
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  Future<bool> unpublishPrompt(String promptId) async {
    try {
      String? userId = _firebaseAuth.currentUser?.uid;
      DocumentSnapshot promptSnapshot =
          await _promptsCollection.doc(promptId).get();
      Map<String, dynamic>? promptData =
          promptSnapshot.data() as Map<String, dynamic>?;

      if (promptData != null && promptData['created_by'] == userId) {
        await _promptsCollection.doc(promptId).update({'is_published': false});
        return true;
      } else {
        return false; // Not the creator of the prompt
      }
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  Future<bool> upvotePrompt(String promptId) async {
    try {
      // Upvote a prompt
      String? userId = _firebaseAuth.currentUser?.uid;
      await _promptsCollection
          .doc(promptId)
          .update({'upvotes.$userId': FieldValue.serverTimestamp()});
      return true;
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  Future<bool> downvotePrompt(String promptId) async {
    try {
      // Downvote a prompt
      String? userId = _firebaseAuth.currentUser?.uid;
      await _promptsCollection
          .doc(promptId)
          .update({'downvotes.$userId': FieldValue.serverTimestamp()});
      return true;
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  Future<bool> savePrompt(String promptId) async {
    try {
      // Save a prompt
      String? userId = _firebaseAuth.currentUser?.uid;
      await _usersCollection.doc(userId).update({
        'fav_prompts': FieldValue.arrayUnion([promptId])
      });
      return true;
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  Future<void> sharePrompt(String promptId) async {
    //TODO method for sharing a prompt
  }

  Future<void> reportPrompt(String promptId, String reportReason) async {
    //TODO method for reporting a prompt
  }
}
