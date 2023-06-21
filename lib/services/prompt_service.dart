import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kaiprompt/utils/logger.dart';
import 'package:kaiprompt/models/prompt.dart';
import 'package:kaiprompt/utils/service_response.dart';

final _firestore = FirebaseFirestore.instance;
final _promptsCollection = _firestore.collection('prompts');
final _usersCollection = _firestore.collection('users');

final promptServiceProvider =
    StateNotifierProvider<PromptService, PromptModel?>(
        (ref) => PromptService(FirebaseAuth.instance));

class PromptService extends StateNotifier<PromptModel?> {
  final FirebaseAuth _firebaseAuth;
  DocumentSnapshot? _lastDocument;

  PromptService(this._firebaseAuth) : super(null);

// Fetch prompts with pagination, ordering, and filtering
  Future<ServiceResponse<List<PromptModel>>> fetchPrompts({
    int batch = 10,
    String orderBy = 'created_at',
    bool descending = true,
    Map<String, dynamic>? filters,
  }) async {
    try {
      Query query = _promptsCollection
          .orderBy(orderBy, descending: descending)
          .limit(batch);

      // If we have a last document from the previous batch,
      // start the query after it
      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      // Apply filters to the query
      if (filters != null) {
        filters.forEach((field, value) {
          query = query.where(field, isEqualTo: value);
        });
      }

      QuerySnapshot querySnapshot = await query.get();

      // If no documents are fetched, we have reached the end
      if (querySnapshot.docs.isEmpty) {
        throw Exception('No more prompts to fetch.');
      }

      // If we have fetched any documents, store the last one
      // for the next batch
      _lastDocument = querySnapshot.docs.last;

      // Map the documents to PromptModel instances
      List<PromptModel> prompts = querySnapshot.docs.map((doc) {
        return PromptModel.fromDocument(doc);
      }).toList();

      return ServiceResponse<List<PromptModel>>(data: prompts);
    } catch (e) {
      logger.e(e);
      return ServiceResponse<List<PromptModel>>(error: e.toString());
    }
  }

  Future<ServiceResponse<bool>> createPrompt(String title,
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
      return ServiceResponse<bool>(data: true);
    } catch (e) {
      logger.e(e);
      return ServiceResponse<bool>(error: e.toString());
    }
  }

  Future<ServiceResponse<bool>> editPrompt(
      String promptId, String title, List<String> tags) async {
    try {
      // Edit an existing prompt
      await _promptsCollection
          .doc(promptId)
          .update({'title': title, 'tags': tags});
      return ServiceResponse<bool>(data: true);
    } catch (e) {
      logger.e(e);
      return ServiceResponse<bool>(error: e.toString());
    }
  }

  Future<ServiceResponse<bool>> publishPrompt(String promptId) async {
    try {
      String? userId = _firebaseAuth.currentUser?.uid;
      DocumentSnapshot promptSnapshot =
          await _promptsCollection.doc(promptId).get();
      Map<String, dynamic>? promptData =
          promptSnapshot.data() as Map<String, dynamic>?;

      if (promptData != null && promptData['created_by'] == userId) {
        await _promptsCollection.doc(promptId).update({'is_published': true});
        return ServiceResponse<bool>(data: true);
      } else {
        return ServiceResponse<bool>(
            error:
                "Not the creator of the prompt"); // Not the creator of the prompt
      }
    } catch (e) {
      logger.e(e);
      return ServiceResponse<bool>(error: e.toString());
    }
  }

  Future<ServiceResponse<bool>> unpublishPrompt(String promptId) async {
    try {
      String? userId = _firebaseAuth.currentUser?.uid;
      DocumentSnapshot promptSnapshot =
          await _promptsCollection.doc(promptId).get();
      Map<String, dynamic>? promptData =
          promptSnapshot.data() as Map<String, dynamic>?;

      if (promptData != null && promptData['created_by'] == userId) {
        await _promptsCollection.doc(promptId).update({'is_published': false});
        return ServiceResponse<bool>(data: true);
      } else {
        return ServiceResponse<bool>(
            error:
                'Not the creator of the prompt'); // Not the creator of the prompt
      }
    } catch (e) {
      logger.e(e);
      return ServiceResponse<bool>(error: e.toString());
    }
  }

  Future<ServiceResponse<bool>> onUpvotePrompt(String promptId) async {
    try {
      // Upvote a prompt
      String? userId = _firebaseAuth.currentUser?.uid;
      await _promptsCollection
          .doc(promptId)
          .update({'upvotes.$userId': FieldValue.serverTimestamp()});
      return ServiceResponse<bool>(data: true);
    } catch (e) {
      logger.e(e);
      return ServiceResponse<bool>(error: e.toString());
    }
  }

  Future<ServiceResponse<bool>> onDownvotePrompt(String promptId) async {
    try {
      // Downvote a prompt
      String? userId = _firebaseAuth.currentUser?.uid;
      await _promptsCollection
          .doc(promptId)
          .update({'downvotes.$userId': FieldValue.serverTimestamp()});
      return ServiceResponse<bool>(data: true);
    } catch (e) {
      logger.e(e);
      return ServiceResponse<bool>(error: e.toString());
    }
  }

  Future<ServiceResponse<bool>> onSavePrompt(String promptId) async {
    try {
      // Save a prompt
      String? userId = _firebaseAuth.currentUser?.uid;
      await _usersCollection.doc(userId).update({
        'fav_prompts': FieldValue.arrayUnion([promptId])
      });
      return ServiceResponse<bool>(data: true);
    } catch (e) {
      logger.e(e);
      return ServiceResponse<bool>(error: e.toString());
    }
  }

  Future<void> sharePrompt(String promptId) async {
    //TODO method for sharing a prompt
  }

  Future<void> reportPrompt(String promptId, String reportReason) async {
    //TODO method for reporting a prompt
  }
}
