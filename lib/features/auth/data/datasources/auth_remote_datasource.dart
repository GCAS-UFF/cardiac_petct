import 'package:cardiac_petct/features/auth/data/models/user_model.dart';
import 'package:cardiac_petct/features/auth/domain/erros/auth_failures.dart';
import 'package:cardiac_petct/src/constants/firebase_keys.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

abstract class AuthRemoteDatasource {
  Future<void> registration(UserModel userModel, String password);
  Future<bool> confirmEmailVerified();
  Future<void> sendEmailVerification();
  Future<void> login(String email, String password);
  Future<void> recoverPassword(String email);
  Future<void> signOut();
}

class AuthRemoteDatasourceImp implements AuthRemoteDatasource {
  late final FirebaseAuth firebaseAuth;
  late final FirebaseDatabase firebaseDatabase;
  AuthRemoteDatasourceImp() {
    init();
  }

  void init() {
    firebaseAuth = FirebaseAuth.instance;
    firebaseDatabase = FirebaseDatabase.instance;
  }

  @override
  Future<void> registration(UserModel userModel, String password) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
          email: userModel.email, password: password);
      final firebaseUser = userCredential.user;
      DatabaseReference userReference = firebaseDatabase
          .ref()
          .child(FirebaseKeys.users)
          .child(firebaseUser!.uid);
      userModel = userModel.copyWith(id: firebaseUser.uid);
      await userReference.set(userModel.toMap());
      sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      if (e.code == FirebaseKeys.emailAlreadyInUseErrorMessage) {
        throw UserAlreadyInUse();
      }
    }
  }

  @override
  Future<bool> confirmEmailVerified() async {
    try {
      await firebaseAuth.currentUser!.reload();
      final firebaseUser = firebaseAuth.currentUser;
      return firebaseUser!.emailVerified;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      await firebaseAuth.currentUser!.sendEmailVerification();
    } on FirebaseAuthException {
      rethrow;
    }
  }

  @override
  Future<void> login(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == FirebaseKeys.wrongPasswordErrorMessage) {
        throw WrongPassword();
      }
      if (e.code == FirebaseKeys.userNotFoundErrorMessage) {
        throw UserNotFound();
      }
      rethrow;
    }
  }

  @override
  Future<void> recoverPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == FirebaseKeys.userNotFoundErrorMessage) {
        throw UserNotFound();
      }
      if (e.code == FirebaseKeys.invalidEmailErrorMessage) {
        throw InvalidEmail();
      }
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } on FirebaseAuthException {
      rethrow;
    }
  }
}
