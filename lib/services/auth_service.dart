import 'package:e_connect_mobile/data/models/user.dart';
import 'package:e_connect_mobile/utils/app_utils.dart';
import 'package:e_connect_mobile/utils/exception.dart';
import 'package:e_connect_mobile/utils/hive.dart';
import 'package:e_connect_mobile/utils/notification_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _users = Collection.user;

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
      await Collection.user.doc(response.user!.uid).update(
        {"fcm_id": await NotificationUtils.getFcmToken()},
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
      NotificationUtils.onLogout();
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (error) {
      return ApiError.unknown(error);
    }
  }

  Future getUser(String uid) async {
    try {
      final document = await _users.doc(uid).get();
      if (document.data() == null) {
        return "User profile not found!";
      }
      Map<String, dynamic> data = document.data()!;

      return UserAccount.fromJson(data);
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (error) {
      return error.toString();
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
