import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> register(String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
