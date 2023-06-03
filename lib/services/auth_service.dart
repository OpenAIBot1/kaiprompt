import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

final logger = Logger();

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

  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      // TODO: handle exception
      logger.e(e);
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

  Future<void> register(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      // TODO: handle exception
      logger.e(e);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      // TODO: handle exception
      logger.e(e);
    }
  }
}
