import 'package:e_connect_mobile/ui/constants/colors.dart';
import 'package:e_connect_mobile/ui/screens/chat/chat_bottom_navitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BottomNavItem {
  final String title;
  final String iconPath;

  BottomNavItem({required this.title, required this.iconPath});
}

class BottomNavItemContainer extends StatefulWidget {
  final BoxConstraints boxConstraints;
  final int index;
  final int currentIndex;
  final AnimationController animationController;
  final BottomNavItem bottomNavItem;
  final Function onTap;
  const BottomNavItemContainer(
      {Key? key,
      required this.boxConstraints,
      required this.currentIndex,
      required this.bottomNavItem,
      required this.animationController,
      required this.onTap,
      required this.index})
      : super(key: key);

  @override
  State<BottomNavItemContainer> createState() => _BottomNavItemContainerState();
}

class _BottomNavItemContainerState extends State<BottomNavItemContainer> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        widget.onTap(widget.index);
      },
      child: SizedBox(
        width: widget.boxConstraints.maxWidth * (0.25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SlideTransition(
              position: Tween<Offset>(
                      begin: const Offset(0.0, 0.05),
                      end: const Offset(0.0, 0.35))
                  .animate(
                CurvedAnimation(
                    parent: widget.animationController,
                    curve: Curves.easeInOut),
              ),
              // child: const Icon(Icons.home),
              child: widget.index == 1
                  ? ChatBottomNavItem(
                      isActive: widget.index == widget.currentIndex,
                    )
                  : SvgPicture.asset(
                      widget.bottomNavItem.iconPath,
                      // ignore: deprecated_member_use
                      color: widget.index == widget.currentIndex
                          ? primaryColor
                          : secondaryDark,
                    ),
            ),
            SizedBox(
              height: widget.boxConstraints.maxHeight * (0.051),
            ),
            FadeTransition(
              opacity: Tween<double>(begin: 1.0, end: 0.0)
                  .animate(widget.animationController),
              child: SlideTransition(
                position: Tween<Offset>(
                        begin: const Offset(0.0, 0.0),
                        end: const Offset(0.0, 0.5))
                    .animate(
                  CurvedAnimation(
                      parent: widget.animationController,
                      curve: Curves.easeInOut),
                ),
                child: Text(
                  widget.bottomNavItem.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: widget.index == widget.currentIndex
                        ? primaryColor
                        : secondaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
