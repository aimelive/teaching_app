import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_connect_mobile/data/controllers/auth.dart';
import 'package:e_connect_mobile/ui/constants/colors.dart';
import 'package:e_connect_mobile/ui/helpers/ui_utils.dart';
import 'package:e_connect_mobile/ui/screens/home/widgets/bottom_nav_item.dart';
import 'package:e_connect_mobile/ui/screens/home/widgets/chat_container.dart';
import 'package:e_connect_mobile/ui/screens/home/widgets/home_container.dart';
import 'package:e_connect_mobile/ui/screens/home/widgets/timetable_container.dart';
import 'package:e_connect_mobile/ui/screens/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500));

  late final Animation<double> _bottomNavAndTopProfileAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _animationController, curve: Curves.easeInOut));

  final authState = Get.find<AuthState>();

  late final List<AnimationController> _bottomNavItemTitlesAnimationController =
      [];

  final List<BottomNavItem> _bottomNavItems = [
    BottomNavItem(
      title: "Home",
      iconPath: getIconPath("home"),
    ),
    BottomNavItem(
      title: "Chats",
      iconPath: getIconPath("chat"),
    ),
    BottomNavItem(
      title: "Calendar",
      iconPath: getIconPath("calendar"),
    ),
    BottomNavItem(
      title: "Menu",
      iconPath: getIconPath("menu"),
    ),
  ];

  Widget getPage(int index) {
    switch (index) {
      case 0:
        return const HomeContainer();
      case 1:
        return const ChatContainer();
      case 2:
        return const TimeTableContainer();
      default:
        return const SizedBox.shrink();
    }
  }

  late Widget currentPage;

  late int _currentSelectedBottomNavIndex = 0;

  void changeBottomNavItem(int index) async {
    if (index == _bottomNavItems.length - 1) {
      showMoreBottomSheet();
      return;
    }
    _bottomNavItemTitlesAnimationController[_currentSelectedBottomNavIndex]
        .forward();

    //change current selected bottom index
    setState(() {
      _currentSelectedBottomNavIndex = index;
      currentPage = getPage(index);
    });

    _bottomNavItemTitlesAnimationController[_currentSelectedBottomNavIndex]
        .reverse();
  }

  Future<dynamic> showMoreBottomSheet() {
    return showModalBottomSheet(
        context: context,
        backgroundColor: whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15.r),
          ),
        ),
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.w,
                  height: 8.h,
                  margin: EdgeInsets.all(5.r),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                GestureDetector(
                  onTap: () {
                    popPage(context);
                    pushPage(
                      context,
                      to: ProfileScreen(user: authState.user.value!),
                    );
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40.r,
                        foregroundImage: CachedNetworkImageProvider(
                            authState.user.value!.profilePic),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authState.user.value!.names,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(authState.user.value!.role.name),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.w),
                      const Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    currentPage = getPage(0);
    initAnimations();

    _animationController.forward();
  }

  void initAnimations() {
    for (var i = 0; i < _bottomNavItems.length; i++) {
      _bottomNavItemTitlesAnimationController.add(
        AnimationController(
          value: i == _currentSelectedBottomNavIndex ? 0.0 : 1.0,
          vsync: this,
          duration: const Duration(milliseconds: 400),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPage,
      bottomNavigationBar: FadeTransition(
        opacity: _bottomNavAndTopProfileAnimation,
        child: SlideTransition(
          position: _bottomNavAndTopProfileAnimation.drive(
              Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero)),
          child: Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(
              bottom: 15.h,
            ),
            margin: const EdgeInsets.only(
              bottom: 30,
              right: 25,
              left: 25,
            ),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: secondaryColor.withOpacity(0.15),
                  offset: const Offset(2.5, 2.5),
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
              ],
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(25.r),
            ),
            width: MediaQuery.of(context).size.width * (0.85),
            height: MediaQuery.of(context).size.height * 0.08,
            child: LayoutBuilder(builder: (context, boxConstraints) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _bottomNavItems.map((bottomNavItem) {
                  int index = _bottomNavItems
                      .indexWhere((e) => e.title == bottomNavItem.title);
                  return BottomNavItemContainer(
                    boxConstraints: boxConstraints,
                    currentIndex: _currentSelectedBottomNavIndex,
                    bottomNavItem: _bottomNavItems[index],
                    animationController:
                        _bottomNavItemTitlesAnimationController[index],
                    onTap: changeBottomNavItem,
                    index: index,
                  );
                }).toList(),
              );
            }),
          ),
        ),
      ),
    );
  }
}
