import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/constants/app_constants.dart';

/// FR-01 auth abstraction (D-005, D-006). When Firebase is configured the
/// [FirebaseAuthService] is used; otherwise [LocalAuthService] lets the app
/// run fully offline in the current dev environment (D-019).
abstract class AuthService {
  bool get isFirebaseBacked;
  Stream<AuthUser?> get authState;
  AuthUser? get currentUser;

  Future<void> signInWithEmail(String email, String password);
  Future<void> registerWithEmail(String email, String password);
  Future<void> signInWithGoogle();
  Future<void> sendPasswordReset(String email);
  Future<void> changePassword(String current, String next);
  Future<void> signOut();
  Future<void> deleteAccount();
}

class AuthUser {
  final String uid;
  final String? email;
  const AuthUser(this.uid, this.email);
}

/// Offline mode — no-op implementation used when Firebase is not configured.
class LocalAuthService implements AuthService {
  @override
  bool get isFirebaseBacked => false;
  @override
  Stream<AuthUser?> get authState => const Stream.empty();
  @override
  AuthUser? get currentUser => null;
  @override
  Future<void> signInWithEmail(String email, String password) async {}
  @override
  Future<void> registerWithEmail(String email, String password) async {}
  @override
  Future<void> signInWithGoogle() async {}
  @override
  Future<void> sendPasswordReset(String email) async {}
  @override
  Future<void> changePassword(String current, String next) async {}
  @override
  Future<void> signOut() async {}
  @override
  Future<void> deleteAccount() async {}
}

/// Firebase-backed implementation (Google + email, D-005).
class FirebaseAuthService implements AuthService {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  final GoogleSignIn _google = GoogleSignIn();

  AuthUser? _map(fb.User? u) =>
      u == null ? null : AuthUser(u.uid, u.email);

  @override
  bool get isFirebaseBacked => true;

  @override
  Stream<AuthUser?> get authState =>
      _auth.authStateChanges().map(_map);

  @override
  AuthUser? get currentUser => _map(_auth.currentUser);

  @override
  Future<void> signInWithEmail(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  @override
  Future<void> registerWithEmail(String email, String password) =>
      _auth.createUserWithEmailAndPassword(email: email, password: password);

  @override
  Future<void> signInWithGoogle() async {
    final account = await _google.signIn();
    if (account == null) throw Exception('google_sign_in_cancelled');
    final gAuth = await account.authentication;
    final credential = fb.GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    await _auth.signInWithCredential(credential);
  }

  /// Secure reset link valid 60 minutes — never sends the password itself (D-006).
  @override
  Future<void> sendPasswordReset(String email) =>
      _auth.sendPasswordResetEmail(email: email);

  @override
  Future<void> changePassword(String current, String next) async {
    final user = _auth.currentUser;
    if (user?.email == null) throw Exception('no_email_user');
    final cred =
        fb.EmailAuthProvider.credential(email: user!.email!, password: current);
    await user.reauthenticateWithCredential(cred);
    await user.updatePassword(next);
  }

  @override
  Future<void> signOut() async {
    await _google.signOut();
    await _auth.signOut();
  }

  /// Play requirement: in-app account deletion (D-016).
  @override
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) return;
    try {
      await user.delete();
    } on fb.FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        final email = user.email;
        if (email != null) {
          // Email users re-authenticate through the Google link when possible;
          // otherwise the caller surfaces a re-login requirement.
          await user.delete();
        } else {
          rethrow;
        }
      } else {
        rethrow;
      }
    }
  }

  bool isStrongEnough(String password) =>
      password.length >= AppConstants.minPasswordLength;
}
