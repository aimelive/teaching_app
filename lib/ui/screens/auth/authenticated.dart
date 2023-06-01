import 'package:e_connect_mobile/utils/notification_utils.dart';
import 'package:flutter/material.dart';

import '../../../data/providers/chats_provider.dart';
import '../../../data/providers/schools_provider.dart';
import '../home/home.dart';

class AuthenticatedWrapper extends StatefulWidget {
  const AuthenticatedWrapper({super.key});

  @override
  State<AuthenticatedWrapper> createState() => _AuthenticatedWrapperState();
}

class _AuthenticatedWrapperState extends State<AuthenticatedWrapper> {
  @override
  void initState() {
    NotificationUtils.listenActionStream(context, mounted);
    NotificationUtils.setUpNotificationService(context, mounted);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const ChatsProvider(
      child: SchoolsProvider(
        child: HomeScreen(),
      ),
    );
  }
}
