import 'package:e_connect_mobile/data/controllers/auth.dart';
import 'package:e_connect_mobile/ui/screens/auth/authenticated.dart';
import 'package:e_connect_mobile/ui/screens/auth/welcome_screen.dart';
import 'package:e_connect_mobile/utils/hive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final auth = Get.put(AuthState());

  final _hiveDb = HiveUtils();

  _init() {
    final account = _hiveDb.getAuth();
    if (account != null) {
      auth.user.value = account;
    }
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => (auth.user.value != null)
          ? const AuthenticatedWrapper()
          : const WelcomeScreen(),
    );
  }
}
