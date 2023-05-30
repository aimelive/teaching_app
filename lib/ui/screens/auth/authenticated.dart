import 'package:flutter/material.dart';

import '../../../data/providers/chats_provider.dart';
import '../../../data/providers/schools_provider.dart';
import '../home/home.dart';

class AuthenticatedWrapper extends StatelessWidget {
  const AuthenticatedWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChatsProvider(
      child: SchoolsProvider(
        child: HomeScreen(),
      ),
    );
  }
}
