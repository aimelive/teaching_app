import 'package:e_connect_mobile/data/models/user.dart';
import 'package:get/get.dart';

class AuthState extends GetxController {
  RxBool isSignedIn = RxBool(false);
  RxString email = RxString("");
  RxString token = RxString("");
  var user = Rx<User?>(null);
}
