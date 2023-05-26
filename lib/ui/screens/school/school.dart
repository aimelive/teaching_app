import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_connect_mobile/data/models/school.dart';
import 'package:e_connect_mobile/ui/constants/colors.dart';
import 'package:e_connect_mobile/ui/helpers/ui_utils.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SchoolScreen extends StatefulWidget {
  final School school;
  const SchoolScreen({super.key, required this.school});

  @override
  State<SchoolScreen> createState() => _SchoolScreenState();
}

class _SchoolScreenState extends State<SchoolScreen> {
  // late String _selectedTabTitle = "Teachers";

  @override
  Widget build(BuildContext context) {
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
                          badges.Badge(
                            badgeContent: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                "2",
                                style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                            position: badges.BadgePosition.topEnd(),
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.school),
                              style: ElevatedButton.styleFrom(
                                elevation: 0.0,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                              label: const Text("Classes"),
                            ),
                          )
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
                  addVerticalSpace(5),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.public,
                      color: whiteColor,
                    ),
                    label: const Text(
                      "Our Website",
                      style: TextStyle(
                        color: whiteColor,
                      ),
                    ),
                  )
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
                  addVerticalSpace(10),
                  Text(
                    "Principal",
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
                      child: const Icon(Icons.verified_user),
                    ),
                    title: Text(widget.school.principalName),
                    subtitle: Text(widget.school.principalPhone),
                  ),
                  addVerticalSpace(10),
                  Text(
                    "About",
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
                      child: const Icon(Icons.group),
                    ),
                    title: const Text("Teachers and Assistants"),
                    subtitle: Text(
                        "${widget.school.teachers.length}+ techers and assistants"),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 20.r,
                      backgroundColor: primaryColor,
                      foregroundColor: whiteColor,
                      child: const Icon(Icons.school),
                    ),
                    title: const Text("Active Classes"),
                    subtitle: const Text("2+ classes"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
