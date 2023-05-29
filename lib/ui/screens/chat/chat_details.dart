import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_connect_mobile/data/models/user.dart';
import 'package:e_connect_mobile/data/providers/stream_list_provider.dart';
import 'package:e_connect_mobile/ui/helpers/ui_utils.dart';
import 'package:e_connect_mobile/ui/screens/profile/profile.dart';
import 'package:e_connect_mobile/ui/widgets/custom_error_widget.dart';
import 'package:e_connect_mobile/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swipe_image_gallery/swipe_image_gallery.dart';

import '../../../data/models/chat.dart';
import '../../constants/colors.dart';

class ChatDetails extends StatelessWidget {
  const ChatDetails({
    super.key,
    required this.description,
    required this.images,
    required this.name,
    required this.profile,
    required this.totalChats,
    required this.isGroup,
    required this.members,
    required this.currentUserId,
  });

  final String profile;
  final String name;
  final String description;
  final int totalChats;
  final List<ChatMessage> images;
  final List<String> members;
  final bool isGroup;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomBackAppbar(
              title: "${isGroup ? "Group" : "User"} Info",
              color: Colors.black,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                addVerticalSpace(10),
                CircleAvatar(
                  foregroundImage: CachedNetworkImageProvider(profile),
                  radius: 60.r,
                ),
                addVerticalSpace(10),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                addVerticalSpace(5),
                Text(description),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total messages: $totalChats"),
                  addVerticalSpace(5),
                  Text("Media Files: ${images.length}"),
                  if (images.isNotEmpty) addVerticalSpace(15),
                  if (images.isNotEmpty)
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            final image =
                                images.reversed.toList()[index].image!;
                            final caption =
                                images.reversed.toList()[index].message;
                            return GestureDetector(
                              onTap: () => SwipeImageGallery(
                                context: context,
                                children: [
                                  CachedNetworkImage(imageUrl: image),
                                ],
                              ).show(),
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: index == 0 ? 0 : 12.w),
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(6.r),
                                    bottom: Radius.circular(6.r),
                                  ),
                                ),
                                width: 150,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(6.r),
                                        child: CachedNetworkImage(
                                          imageUrl: image,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        caption,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: whiteColor,
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  addVerticalSpace(5),
                  if (isGroup) const Text("Group Members:"),
                  if (isGroup)
                    StreamListProvider<UserAccount>(
                      query: Collection.user.where('id', whereIn: members),
                      fromJson: (json,id) => UserAccount.fromJson(json),
                      loading: const Text("Loading..."),
                      onError: (e) => CustomErrorWidget(error: e),
                      onSuccess: (users) {
                        if (users.isEmpty) {
                          return const CustomErrorWidget(
                            error: "Group has no members",
                          );
                        }
                        return Column(
                          children: users
                              .map(
                                (user) => ListTile(
                                  leading: CircleAvatar(
                                    radius: 20.r,
                                    backgroundColor: primaryColor,
                                    foregroundColor: whiteColor,
                                    foregroundImage: CachedNetworkImageProvider(
                                      user.profilePic,
                                    ),
                                    child: const Icon(Icons.verified_user),
                                  ),
                                  title: Text(
                                      "${user.names} ${user.id == currentUserId ? "(You)" : ""}"),
                                  subtitle: Text(user.role.name),
                                ),
                              )
                              .toList(),
                        );
                      },
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
