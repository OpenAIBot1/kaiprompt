import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kaiprompt/utils/logger.dart';
import 'package:kaiprompt/utils/service_response.dart';
import 'package:google_sign_in/google_sign_in.dart';

final _firestore = FirebaseFirestore.instance;
final _usersCollection = _firestore.collection('users');
final GoogleSignIn _googleSignIn = GoogleSignIn();

// Declare the provider
final authServiceProvider = StateNotifierProvider<AuthService, User?>(
    (ref) => AuthService(FirebaseAuth.instance));

class AuthService extends StateNotifier<User?> {
  final FirebaseAuth _firebaseAuth;

  AuthService(this._firebaseAuth) : super(_firebaseAuth.currentUser) {
    _firebaseAuth.authStateChanges().listen((user) {
      state = user;
    });
  }

  User? getCurrentUser() {
    return state;
  }

  Future<ServiceResponse<bool>> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return ServiceResponse(data: true);
    } catch (e) {
      logger.e(e);
      return ServiceResponse(error: e.toString());
    }
  }

  Future<ServiceResponse<void>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return ServiceResponse(data: null);
    } catch (e) {
      logger.e(e);
      return ServiceResponse(error: e.toString());
    }
  }

  Future<ServiceResponse<bool>> register(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        await _usersCollection.doc(userCredential.user!.uid).set({
          'user_id': userCredential.user!.uid,
          'created_at': FieldValue.serverTimestamp(),
          'username': '',
          'profile_pic': '',
          'description': '',
          'is_restricted': false,
          'fav_prompts': [],
          'created_prompts': [],
          'upvoted_prompts': {},
          'downvoted_prompts': {},
        });
        return ServiceResponse(data: true);
      } else {
        logger.e('User is null after creating account');
        return ServiceResponse(error: 'User is null after creating account');
      }
    } catch (e) {
      logger.e(e);
      return ServiceResponse(error: e.toString());
    }
  }

  Future<ServiceResponse<bool>> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return ServiceResponse(data: true);
    } catch (e) {
      logger.e(e);
      return ServiceResponse(error: e.toString());
    }
  }

  Future<ServiceResponse<bool>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return ServiceResponse(data: false);
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('user_id', isEqualTo: userCredential.user!.uid)
          .get();

      if (querySnapshot.docs.isEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'user_id': userCredential.user!.uid,
          'created_at': FieldValue.serverTimestamp(),
          'username': '',
          'profile_pic': '',
          'description': '',
          'is_restricted': false,
          'fav_prompts': [],
          'created_prompts': [],
          'upvoted_prompts': {},
          'downvoted_prompts': {},
        });
      }

      return ServiceResponse(data: true);
    } catch (e) {
      logger.e(e);
      return ServiceResponse(error: e.toString());
    }
  }
}
