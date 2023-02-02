import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_exceptions.dart';


class AuthenticationService {
  static final auth = FirebaseAuth.instance;
  static AuthStatus? _status;

  /*Future<AuthStatus> login({
    required String email,
    required String password,
  }) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      _status = AuthStatus.successful;
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleAuthException(e);
    }
    return _status;
  }

  Future<AuthStatus> createAccount({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      UserCredential newUser = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      auth.currentUser!.updateDisplayName(name);
      //_auth.currentUser!.updateProfile(displayName: username);

      newUser.user!.sendEmailVerification();

      _status = AuthStatus.successful;
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleAuthException(e);
    }
    return _status;
  }*/

  Future<AuthStatus> resetPassword({required String email}) async {
    await auth
        .sendPasswordResetEmail(email: email)
        .then((value) => _status = AuthStatus.successful)
        .catchError(
            (e) => _status = AuthExceptionHandler.handleAuthException(e));

    return _status!;
  }

  Future<void> logout() async {
    await auth.signOut();
  }
}