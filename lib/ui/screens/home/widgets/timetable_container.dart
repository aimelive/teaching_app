import 'package:e_connect_mobile/ui/constants/colors.dart';
import 'package:e_connect_mobile/ui/helpers/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimeTableContainer extends StatefulWidget {
  const TimeTableContainer({
    Key? key,
  }) : super(key: key);

  @override
  State<TimeTableContainer> createState() => _TimeTableContainerState();
}

class _TimeTableContainerState extends State<TimeTableContainer> {
  late int _currentSelectedDayIndex = DateTime.now().weekday - 1;

  Widget _buildDayContainer(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          _currentSelectedDayIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: index == _currentSelectedDayIndex
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent),
        padding: const EdgeInsets.all(7.5),
        child: Text(
          weekDays[index],
          style: TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.w600,
              color: index == _currentSelectedDayIndex
                  ? Theme.of(context).scaffoldBackgroundColor
                  : Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }

  Widget _buildDays() {
    final List<Widget> children = [];

    for (var i = 0; i < weekDays.length; i++) {
      children.add(_buildDayContainer(i));
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width * (0.85),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        children: [
          SafeArea(
            bottom: false,
            right: false,
            left: false,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
              child: Row(
                children: [
                  Text(
                    "Time Table",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w800,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          _buildDays(),
          SizedBox(
            height: MediaQuery.of(context).size.height * (0.025),
          ),
          Container(
            clipBehavior: Clip.none,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.075),
                      offset: const Offset(4, 4),
                      blurRadius: 10,
                      spreadRadius: 0)
                ],
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(10)),
            width: MediaQuery.of(context).size.width * (0.85),
            padding: const EdgeInsets.symmetric(horizontal: 12.5, vertical: 10.0),
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: const Icon(
                    Icons.school,
                    color: whiteColor,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "04:00 PM - 06:00 PM",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0),
                      ),
                      const Text(
                        "Mathematics",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: secondaryDark,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0),
                      ),
                      const Text(
                        "Aime Ndayambaje",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: secondaryDark,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            clipBehavior: Clip.none,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.075),
                      offset: const Offset(4, 4),
                      blurRadius: 10,
                      spreadRadius: 0)
                ],
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(10)),
            width: MediaQuery.of(context).size.width * (0.85),
            padding: const EdgeInsets.symmetric(horizontal: 12.5, vertical: 10.0),
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: const Icon(
                    Icons.school,
                    color: whiteColor,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "04:00 PM - 06:00 PM",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0),
                      ),
                      const Text(
                        "Mathematics",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: secondaryDark,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0),
                      ),
                      const Text(
                        "Aime Ndayambaje",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: secondaryDark,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            clipBehavior: Clip.none,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.075),
                      offset: const Offset(4, 4),
                      blurRadius: 10,
                      spreadRadius: 0)
                ],
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(10)),
            width: MediaQuery.of(context).size.width * (0.85),
            padding: const EdgeInsets.symmetric(horizontal: 12.5, vertical: 10.0),
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: const Icon(
                    Icons.school,
                    color: whiteColor,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "04:00 PM - 06:00 PM",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0),
                      ),
                      const Text(
                        "Mathematics",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: secondaryDark,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0),
                      ),
                      const Text(
                        "Aime Ndayambaje",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: secondaryDark,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            clipBehavior: Clip.none,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.075),
                      offset: const Offset(4, 4),
                      blurRadius: 10,
                      spreadRadius: 0)
                ],
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(10)),
            width: MediaQuery.of(context).size.width * (0.85),
            padding: const EdgeInsets.symmetric(horizontal: 12.5, vertical: 10.0),
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: const Icon(
                    Icons.school,
                    color: whiteColor,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "04:00 PM - 06:00 PM",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0),
                      ),
                      const Text(
                        "Mathematics",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: secondaryDark,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0),
                      ),
                      const Text(
                        "Aime Ndayambaje",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: secondaryDark,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
