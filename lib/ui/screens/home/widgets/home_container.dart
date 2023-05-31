import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_connect_mobile/data/controllers/auth.dart';
import 'package:e_connect_mobile/data/controllers/school.dart';
import 'package:e_connect_mobile/data/models/notification.dart';
import 'package:e_connect_mobile/data/providers/stream_list_provider.dart';
import 'package:e_connect_mobile/ui/constants/colors.dart';
import 'package:e_connect_mobile/ui/helpers/ui_utils.dart';
import 'package:e_connect_mobile/ui/screens/classes/home_teacher_class_container.dart';
import 'package:e_connect_mobile/ui/screens/notification/notifications_page.dart';
import 'package:e_connect_mobile/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;

import 'school_card.dart';

class HomeContainer extends StatefulWidget {
  const HomeContainer({super.key});

  @override
  State<HomeContainer> createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  final authState = Get.find<AuthState>();
  final schoolState = Get.find<SchoolsState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor.withOpacity(0.01),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            addVerticalSpace(15),
            SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 25.r,
                    foregroundImage: CachedNetworkImageProvider(
                      authState.user.value!.profilePic,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => pushPage(
                      context,
                      to: NotificationsPage(),
                    ),
                    child: StreamListProvider<AppNotification>(
                      query: Collection.notification
                          .where('to', isEqualTo: authState.user.value!.id)
                          .where(
                            'viewed',
                            isEqualTo: false,
                          ),
                      fromJson: (json, id) => AppNotification.fromJson(json,id),
                      loading: SvgPicture.asset(
                        getIconPath("notification"),
                        height: 28.sp,
                        // ignore: deprecated_member_use
                        color: secondaryDark,
                      ),
                      onError: (error) {
                        print(error);
                        return badges.Badge(
                          badgeContent: Text(
                            "!",
                            style:
                                TextStyle(color: whiteColor, fontSize: 10.sp),
                          ),
                          showBadge: true,
                          position: badges.BadgePosition.topEnd(),
                          child: SvgPicture.asset(
                            getIconPath("notification"),
                            height: 28.sp,
                            // ignore: deprecated_member_use
                            color: secondaryDark,
                          ),
                        );
                      },
                      onSuccess: (notifications) {
                        return badges.Badge(
                          badgeContent: Text(
                            "${notifications.length}",
                            style:
                                TextStyle(color: whiteColor, fontSize: 10.sp),
                          ),
                          showBadge: notifications.isNotEmpty,
                          position: badges.BadgePosition.topEnd(),
                          child: SvgPicture.asset(
                            getIconPath("notification"),
                            height: 28.sp,
                            // ignore: deprecated_member_use
                            color: secondaryDark,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            addVerticalSpace(20),
            Text(
              "Hello, ${authState.user.value!.names}!",
              style: TextStyle(
                fontSize: 25.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            const TeacherClassesHomeContainer(),
            addVerticalSpace(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Schools",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (schoolState.schools.length > 3)
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextButton.icon(
                      icon: const Icon(
                        Icons.arrow_right_alt,
                        color: primaryColor,
                      ),
                      onPressed: () {},
                      label: const Text(
                        "View More",
                      ),
                    ),
                  ),
              ],
            ),
            addVerticalSpace(15),
            Obx(() {
              if (schoolState.schools.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.error_outline_outlined,
                        size: 30.sp,
                        color: secondaryColor,
                      ),
                      addVerticalSpace(10),
                      Text(
                        "Yet, there are no school assigned to you!",
                        style: TextStyle(
                          fontSize: 15.sp,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return SizedBox(
                height: 160.h,
                child: ListView.builder(
                    itemCount: schoolState.schools.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final active = index == 0;
                      return SchoolCard(
                        active: active,
                        school: schoolState.schools[index],
                      );
                    }),
              );
            }),
            addVerticalSpace(12),
          ],
        ),
      ),
    );
  }
}
