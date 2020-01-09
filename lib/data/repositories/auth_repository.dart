import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

class AuthRepository {
  static final AuthRepository _instance = AuthRepository._internal();

  final FirebaseAuth _fireBaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  factory AuthRepository() {
    return _instance;
  }

  AuthRepository._internal();

  //region ------------------------------Google----------------------------------------
  Future<GoogleSignInAccount> signInSilently() =>
      _googleSignIn.signInSilently(suppressErrors: false);

  Stream<GoogleSignInAccount> onCurrentUserChanged() =>
      _googleSignIn.onCurrentUserChanged;

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser?.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    await _fireBaseAuth.signInWithCredential(credential);
    return _fireBaseAuth.currentUser();
  }

  //endregion

  //-----------------------Email and Password-----------------------------------
  Future<AuthResult> signInWithEmailAndPassword(String email, String password) {
    return _fireBaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<AuthResult> signUpWithEmailAndPassword(
      {@required String email, @required String password}) async {
    try {
      return await _fireBaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on AuthException catch (_) {
      rethrow;
    }
  }

  Future<void> signOut() async {
/*
    return Future.wait([
      _fireBaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
*/
    return await _fireBaseAuth.signOut();
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _fireBaseAuth.currentUser();
    return currentUser != null;
  }

  Future<String> get userId async => (await _fireBaseAuth.currentUser()).uid;

  Future<FirebaseUser> get fireBaseUser => _fireBaseAuth.currentUser();
}
