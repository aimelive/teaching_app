import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_connect_mobile/data/models/user.dart';
import 'package:e_connect_mobile/utils/exception.dart';
import 'package:e_connect_mobile/utils/hive.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _users = FirebaseFirestore.instance.collection('users');

  Stream<User?> get user {
    return _auth.authStateChanges().map((user) => user);
  }

  Future signIn(String email, String password) async {
    try {
      await logOut();
      UserCredential response = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return response.user;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (error) {
      return ApiError.unknown(error);
    }
  }

  //signout
  Future logOut() async {
    try {
      await _auth.signOut();
      await HiveUtils().removeAuth();
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (error) {
      return ApiError.unknown(error);
    }
  }

  Future getUser(String uid) async {
    try {
      final document = await _users.doc(uid).get();
      Map<String, dynamic> data = document.data()!;
      return UserAccount.fromJson(data);
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (error) {
      return ApiError.unknown(error);
    }
  }

  Future forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (error) {
      return ApiError.unknown(error);
    }
  }
}
