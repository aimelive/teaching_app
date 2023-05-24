import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_connect_mobile/data/controllers/auth.dart';
import 'package:e_connect_mobile/data/models/user.dart';
import 'package:e_connect_mobile/ui/screens/chat/users_list.dart';
import 'package:e_connect_mobile/ui/screens/profile/profile.dart';
import 'package:e_connect_mobile/ui/widgets/search_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchUsersChats extends StatefulWidget {
  const SearchUsersChats({super.key});

  @override
  State<SearchUsersChats> createState() => _SearchUsersChatsState();
}

class _SearchUsersChatsState extends State<SearchUsersChats> {
  final _authState = Get.find<AuthState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CustomBackAppbar(title: "New Chat"),
            const SearchInput(),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('id', isNotEqualTo: _authState.user.value!.id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading...");
                  }
                  if (snapshot.hasData) {
                    try {
                      return UsersList(currentUser: _authState.user.value!,
                        users: snapshot.data?.docs
                                .map((DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data()! as Map<String, dynamic>;
                              return UserAccount.fromJson(data);
                            }).toList() ??
                            [],
                      );
                    } catch (e) {
                      return const Text(
                        "Sorry, we could not retrieve users at this time.",
                      );
                    }
                  }
                  return Container();
                })
          ],
        ),
      ),
    );
  }
}
