import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_connect_mobile/data/models/school.dart';
import 'package:e_connect_mobile/data/models/user.dart';
import 'package:e_connect_mobile/ui/constants/colors.dart';
import 'package:e_connect_mobile/ui/helpers/ui_utils.dart';
import 'package:e_connect_mobile/ui/widgets/tab_bar_container.dart';
import 'package:e_connect_mobile/ui/widgets/tab_bar_background_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SchoolScreen extends StatefulWidget {
  final School school;
  const SchoolScreen({super.key, required this.school});

  @override
  State<SchoolScreen> createState() => _SchoolScreenState();
}

class _SchoolScreenState extends State<SchoolScreen> {
  late String _selectedTabTitle = "Teachers";

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
                      IconButton(
                        onPressed: () => popPage(context),
                        icon: Icon(
                          Icons.arrow_back,
                          color: whiteColor,
                          size: 30.sp,
                        ),
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
                          addHorizontalSpace(30),
                          IconButton(
                            icon: const Icon(Icons.edit_square),
                            color: whiteColor,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Text("Hey"),
            Container(
              margin: const EdgeInsets.all(5),
              height: 50.h,
              width: double.infinity,
              child: LayoutBuilder(builder: (context, boxConstraints) {
                return Stack(
                  children: [
                    AnimatedAlign(
                      curve: Curves.easeInOut,
                      duration: const Duration(milliseconds: 300),
                      alignment: _selectedTabTitle == "Teachers"
                          ? AlignmentDirectional.centerStart
                          : _selectedTabTitle == "Assistants"
                              ? AlignmentDirectional.center
                              : AlignmentDirectional.centerEnd,
                      child: TabBarBackgroundContainer(
                        boxConstraints: boxConstraints,
                      ),
                    ),
                    CustomTabBarContainer(
                      boxConstraints: boxConstraints,
                      alignment: AlignmentDirectional.centerStart,
                      isSelected: _selectedTabTitle == "Teachers",
                      onTap: () {
                        setState(() {
                          _selectedTabTitle = "Teachers";
                        });
                      },
                      titleKey: "Teachers",
                    ),
                    CustomTabBarContainer(
                      boxConstraints: boxConstraints,
                      alignment: AlignmentDirectional.center,
                      isSelected: _selectedTabTitle == "Assistants",
                      onTap: () {
                        setState(() {
                          _selectedTabTitle = "Assistants";
                        });
                      },
                      titleKey: "Assistants",
                    ),
                    CustomTabBarContainer(
                      boxConstraints: boxConstraints,
                      alignment: AlignmentDirectional.centerEnd,
                      isSelected: _selectedTabTitle == "PO Manager",
                      onTap: () {
                        setState(() {
                          _selectedTabTitle = "PO Manager";
                        });
                      },
                      titleKey: "PO Manager",
                    ),
                  ],
                );
              }),
            ),
            Column(
              children: [
                dummyUser,
                dummyUser,
                dummyUser,
                dummyUser,
                dummyUser,
              ]
                  .map(
                    (user) => ListTile(
                      onTap: () {},
                      leading: CircleAvatar(
                        radius: 30.r,
                        foregroundImage:
                            CachedNetworkImageProvider(user.profilePic),
                      ),
                      title: Text(user.names),
                      subtitle: Text(_selectedTabTitle),
                      trailing: const Icon(
                        Icons.delete_outline,
                        color: primaryColor,
                      ),
                    ),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
