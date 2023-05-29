import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_connect_mobile/data/controllers/auth.dart';
import 'package:e_connect_mobile/data/models/user.dart';
import 'package:e_connect_mobile/ui/screens/chat/users_list.dart';
import 'package:e_connect_mobile/ui/screens/profile/profile.dart';
import 'package:e_connect_mobile/ui/widgets/custom_error_widget.dart';
import 'package:e_connect_mobile/ui/widgets/search_input.dart';
import 'package:e_connect_mobile/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/providers/stream_list_provider.dart';
import '../../constants/colors.dart';
import '../../helpers/ui_utils.dart';
import '../../widgets/custom_circular_progress.dart';

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
            const CustomBackAppbar(
              title: "New Chat",
              color: Colors.black,
            ),
            SearchInput<UserAccount>(
              onClosed: (data) {
                if (data == null) return;
                popPage<UserAccount>(context, data: data);
              },
              delegate: MyCustomSearchDelegate(
                hintText: "Search user",
                onSearchingSuggestionsBuilder: (query, showResults) {
                  return StreamListProvider<UserAccount>(
                    query: Collection.user.where(
                      'names',
                      isGreaterThanOrEqualTo: query,
                      isLessThan: '${query}z',
                    ),
                    fromJson: (json, id) => UserAccount.fromJson(json),
                    loading: const CustomCircularProgressIndicator(),
                    onError: (error) =>
                        const CustomErrorWidget(error: "Something went wrong"),
                    onSuccess: (messages) {
                      if (messages.isEmpty) {
                        return const CustomErrorWidget(
                          error: "No result found!",
                        );
                      }
                      return ListView.builder(
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final suggestion = messages[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: primaryColor,
                                backgroundImage: CachedNetworkImageProvider(
                                  suggestion.profilePic,
                                ),
                              ),
                              title: Text(suggestion.names),
                              subtitle: Text(suggestion.role.name),
                              onTap: () {
                                query = suggestion.names;
                                showResults(context);
                                popPage(
                                  context,
                                  data: suggestion,
                                );
                              },
                            );
                          });
                    },
                  );
                },
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: Collection.user
                    .where('id', isNotEqualTo: _authState.user.value!.id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading...");
                  }
                  if (snapshot.hasData) {
                    try {
                      if (snapshot.data == null) throw Exception("Error");
                      if (snapshot.data!.docs.isEmpty) {
                        return const Text("No users available to chat with!");
                      }
                      return UsersList(
                        currentUser: _authState.user.value!,
                        users: snapshot.data?.docs
                                .map((DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data()! as Map<String, dynamic>;
                              return UserAccount.fromJson(data);
                            }).toList() ??
                            [],
                      );
                    } catch (e) {
                      return CustomErrorWidget(
                        error:
                            "Sorry, we could not retrieve users at this time. $e",
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
