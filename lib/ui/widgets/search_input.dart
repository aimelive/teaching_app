import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/colors.dart';

class SearchInput extends StatelessWidget {
  const SearchInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.r),
        color: secondaryColor.withOpacity(0.1),
      ),
      child: TextField(
        cursorColor: secondaryColor,
        decoration: InputDecoration(
          isDense: true,
          prefixIconConstraints: BoxConstraints(
            maxHeight: 22.h,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: Icon(
              Icons.search,
              size: 25.sp,
            ),
          ),
          // hintStyle: const TextStyle(color: primaryColor),
          contentPadding: EdgeInsets.symmetric(
            vertical: 12.h,
          ),
          hintText: "Search",
          border: InputBorder.none,
        ),
      ),
    );
  }
}
