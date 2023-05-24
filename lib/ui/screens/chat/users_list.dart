import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_connect_mobile/data/models/chat.dart';
import 'package:e_connect_mobile/data/models/user.dart';
import 'package:e_connect_mobile/ui/helpers/ui_utils.dart';
import 'package:e_connect_mobile/ui/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/colors.dart';

class UsersList extends StatefulWidget {
  const UsersList({
    super.key,
    required this.users,
    required this.currentUser,
  });
  final List<UserAccount> users;
  final UserAccount currentUser;

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  final List<UserAccount> _selected = [];
  bool _isSelecting = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            addHorizontalSpace(15),
            if (_isSelecting)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isSelecting = false;
                  });
                },
                child: const Text("Cancel"),
              ),
            if (_isSelecting) addVerticalSpace(60),
            if (_isSelecting) const Spacer(),
            if (_isSelecting)
              ElevatedButton(
                onPressed: () async {
                  if (_selected.isEmpty) return;
                  final name = await showDialog<String>(
                      context: context,
                      builder: (context) {
                        return const GroupNameDialog();
                      });
                  if (name == null || !mounted) return;
                  final receipints =
                      widget.users.map((user) => user.id).toList();
                  receipints.add(widget.currentUser.id);
                  popPage(
                    context,
                    data: ChatMessage(
                      senderId: widget.currentUser.id,
                      message: "bot",
                      isAutoGenerated: true,
                      isGroup: true,
                      groupInfo: ChatWindowInfo(
                        id: "${widget.currentUser.id}+new-group",
                        avatar:
                            "https://cdn.pixabay.com/photo/2016/08/21/16/31/emoticon-1610228_1280.png",
                        desc: "Group chats",
                        name: name,
                      ),
                      senderInfo: ChatWindowInfo(
                        id: widget.currentUser.id,
                        avatar: widget.currentUser.profilePic,
                        desc: widget.currentUser.role.name,
                        name: name,
                      ),
                      receivers: receipints,
                      views: [widget.currentUser.id],
                      createdAt: Timestamp.now(),
                    ),
                  );
                },
                child: Text("Continue (${_selected.length})"),
              ),
            if (!_isSelecting)
              TextButton.icon(
                icon: const Icon(Icons.group_add),
                onPressed: () {
                  setState(() {
                    _isSelecting = true;
                  });
                },
                label: const Text("New Group"),
              ),
            addHorizontalSpace(15)
          ],
        ),
        Column(
          children: widget.users.map((user) {
            return ListTile(
              onTap: () {
                if (_isSelecting) {
                  if (_selected.contains(user)) {
                    _selected.remove(user);
                  } else {
                    _selected.add(user);
                  }
                  setState(() {});
                  return;
                }
                popPage(context, data: user);
              },
              selected: _selected.contains(user),
              selectedTileColor: Colors.grey.shade200,
              leading: CircleAvatar(
                radius: 25.r,
                foregroundImage: CachedNetworkImageProvider(
                  user.profilePic,
                ),
              ),
              title: Text(user.names),
              subtitle: Text(user.role.name),
              trailing: !_isSelecting
                  ? null
                  : CircleAvatar(
                      backgroundColor: secondaryColor,
                      foregroundColor: whiteColor,
                      radius: 12.r,
                      child: _selected.contains(user)
                          ? Icon(
                              Icons.check,
                              size: 16.sp,
                            )
                          : null,
                    ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class GroupNameDialog extends StatefulWidget {
  const GroupNameDialog({
    super.key,
  });

  @override
  State<GroupNameDialog> createState() => _GroupNameDialogState();
}

class _GroupNameDialogState extends State<GroupNameDialog> {
  final _name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextFieldContainer(
            textEditingController: _name,
            hideText: false,
            hintText: "Enter Group Name",
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => popPage(context),
          child: const Text("cancel"),
        ),
        TextButton(
          onPressed: () => popPage(context, data: _name.text),
          child: const Text("OK"),
        ),
      ],
    );
  }
}