import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:google_sign_in/google_sign_in.dart';

final logger = Logger();
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

  Future<bool> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return true;
    } catch (e) {
      // TODO: handle exception
      logger.e(e);
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      // TODO: handle exception
      logger.e(e);
    }
  }

  Future<bool> register(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Check if the user is not null before accessing the uid
      if (userCredential.user != null) {
        // Create a new user document in Firestore
        await _usersCollection.doc(userCredential.user!.uid).set({
          'user_id': userCredential.user!.uid, // TODO: Set user ID
          'username': '', // TODO: Set username
          'profile_pic': '', // TODO: Set profile picture URL
          'description': '', // TODO: Set description
          'is_restricted': false, // TODO: Set restricted status
          'fav_prompts': [], // TODO: Set favorite prompts
          'created_prompts': [], // TODO: Set created prompts
          'upvoted_prompts': {}, // TODO: Set upvoted prompts
          'downvoted_prompts': {}, // TODO: Set downvoted prompts
        });

        return true;
      } else {
        logger.e('User is null after creating account');
        return false;
      }
    } catch (e) {
      // TODO: handle exception
      logger.e(e);
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      // TODO: handle exception
      logger.e(e);
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return false; // User aborted the sign-in process
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _firebaseAuth.signInWithCredential(credential);
      return true;
    } catch (e) {
      logger.e(e);
      return false;
    }
  }
}
