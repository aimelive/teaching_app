import 'package:e_connect_mobile/data/models/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Boxes {
  static const authBox = "AUTH_BOX";
}

class HiveUtils {
  Box authBox = Hive.box(Boxes.authBox);

  UserAccount? getAuth() {
    try {
      final data = authBox.keys.map((key) {
        final value = authBox.get(key);
        DateTime expiredAt = value["expiredAt"];
        if (!expiredAt.isAfter(DateTime.now())) {
          removeAuth();
          throw Exception("Token expired");
        }
        return userFromJson(value["account"]);
      }).toList();

      return data.reversed.toList().single;
    } catch (e) {
      return null;
    }
  }

  String? getAuthToken() {
    try {
      final data = authBox.keys.map((key) {
        final value = authBox.get(key);
        DateTime expiredAt = value["expiredAt"];
        if (!expiredAt.isAfter(DateTime.now())) {
          removeAuth();
          throw Exception("Token expired");
        }
        return value["authToken"];
      }).toList();
      return data.reversed.toList().single;
    } catch (e) {
      return null;
    }
  }

  Future<bool> addAuth(String token, UserAccount account) async {
    try {
      await removeAuth();
      await authBox.add(
        {
          "authToken": token,
          "expiredAt": DateTime.now().add(const Duration(days: 5)),
          "account": userToJson(account),
        },
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeAuth() async {
    try {
      await authBox.clear();
      return true;
    } catch (e) {
      return false;
    }
  }
}
