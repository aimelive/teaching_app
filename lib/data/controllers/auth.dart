import 'package:e_connect_mobile/data/models/user.dart';
import 'package:get/get.dart';

class AuthState extends GetxController {
  Rx<UserAccount?> user = Rx<UserAccount?>(null);
}
