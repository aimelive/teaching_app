import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_connect_mobile/data/controllers/auth.dart';
import 'package:e_connect_mobile/data/models/school.dart';
import 'package:e_connect_mobile/data/models/teacher_class.dart';
import 'package:e_connect_mobile/data/models/user.dart';
import 'package:e_connect_mobile/data/providers/stream_list_provider.dart';
import 'package:e_connect_mobile/data/providers/stream_provider.dart';
import 'package:e_connect_mobile/ui/constants/colors.dart';
import 'package:e_connect_mobile/ui/helpers/ui_utils.dart';
import 'package:badges/badges.dart' as badges;
import 'package:e_connect_mobile/ui/screens/school/school_classes.dart';
import 'package:e_connect_mobile/ui/widgets/custom_error_widget.dart';
import 'package:e_connect_mobile/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SchoolScreen extends StatefulWidget {
  final School school;
  const SchoolScreen({super.key, required this.school});

  @override
  State<SchoolScreen> createState() => _SchoolScreenState();
}

class _SchoolScreenState extends State<SchoolScreen> {
  final _auth = Get.find<AuthState>();

  @override
  Widget build(BuildContext context) {
    final currentUserRole = _auth.user.value!.role.name == "Teacher Assistant"
        ? 'trAssistantId'
        : 'teacherId';
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 250.h,
              decoration: BoxDecoration(
                color: primaryColor,
                image: DecorationImage(
                  image: CachedNetworkImageProvider(widget.school.image),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                color: Colors.black26,
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => popPage(context),
                            icon: Icon(
                              Icons.arrow_back,
                              color: whiteColor,
                              size: 30.sp,
                            ),
                          ),
                          StreamListProvider<TeacherClass>(
                              query: Collection.classes
                                  .where('schoolId',
                                      isEqualTo: widget.school.id)
                                  .where(
                                    currentUserRole,
                                    isEqualTo: _auth.user.value!.id,
                                  ),
                              fromJson: (json, id) =>
                                  TeacherClass.fromJson(json),
                              loading: Container(),
                              onError: (error) => Container(),
                              onSuccess: (trClasses) {
                                if (trClasses.isEmpty) {
                                  return Container();
                                }
                                return badges.Badge(
                                  badgeContent: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      trClasses.length.toString(),
                                      style: TextStyle(
                                        color: whiteColor,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                  position: badges.BadgePosition.topEnd(),
                                  child: ElevatedButton.icon(
                                    onPressed: () => pushPage(
                                      context,
                                      to: SchoolClassses(
                                        classes: trClasses,
                                        schoolName: widget.school.name,
                                      ),
                                    ),
                                    icon: const Icon(Icons.school),
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0.0,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                    ),
                                    label: const Text("My Classes"),
                                  ),
                                );
                              })
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.school.name,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 25.sp,
                                overflow: TextOverflow.ellipsis,
                                color: whiteColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          addHorizontalSpace(20),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Description:",
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: whiteColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  addVerticalSpace(5),
                  Text(
                    widget.school.description,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: whiteColor,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  addVerticalSpace(15),
                  Text(
                    "School's Location",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: primaryColor,
                    ),
                  ),
                  addVerticalSpace(5),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 20.r,
                      backgroundColor: primaryColor,
                      foregroundColor: whiteColor,
                      child: const Icon(Icons.location_on),
                    ),
                    onTap: () => UiUtils.gotoUrl(widget.school.address.mapLink),
                    title: Text(widget.school.address.location),
                    subtitle: Text(widget.school.address.street),
                    trailing: const Icon(
                      Icons.map,
                    ),
                  ),
                  // addVerticalSpace(10),
                  // Text(
                  //   "Principal",
                  //   style: TextStyle(
                  //     fontSize: 18.sp,
                  //     fontWeight: FontWeight.w800,
                  //     color: primaryColor,
                  //   ),
                  // ),
                  // addVerticalSpace(5),
                  // ListTile(
                  //   leading: CircleAvatar(
                  //     radius: 20.r,
                  //     backgroundColor: primaryColor,
                  //     foregroundColor: whiteColor,
                  //     child: const Icon(Icons.verified_user),
                  //   ),
                  //   title: Text(widget.school.principalName),
                  //   subtitle: Text(widget.school.principalPhone),
                  // ),
                  addVerticalSpace(10),
                  if (widget.school.poManager != null)
                    StreamProvider<UserAccount>(
                      collectionId: Collection.userCollectionId,
                      docId: widget.school.poManager!,
                      fromJson: (json) => UserAccount.fromJson(json),
                      loading: const Text("Loading"),
                      onError: (error) => CustomErrorWidget(error: error),
                      onSuccess: (user) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "PO Manager",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w800,
                                color: primaryColor,
                              ),
                            ),
                            addVerticalSpace(5),
                            ListTile(
                              leading: CircleAvatar(
                                radius: 20.r,
                                backgroundColor: primaryColor,
                                foregroundColor: whiteColor,
                                foregroundImage: CachedNetworkImageProvider(
                                  user.profilePic,
                                ),
                                child: const Icon(Icons.verified_user),
                              ),
                              title: Text(user.names),
                              subtitle: Text(user.tel),
                            ),
                            addVerticalSpace(10),
                          ],
                        );
                      },
                    ),
                  addVerticalSpace(5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
