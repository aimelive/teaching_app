import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_connect_mobile/data/models/school.dart';
import 'package:e_connect_mobile/ui/helpers/ui_utils.dart';
import 'package:e_connect_mobile/ui/screens/school/school.dart';
import 'package:e_connect_mobile/ui/widgets/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/colors.dart';

class SchoolCard extends StatelessWidget {
  final School school;
  const SchoolCard({
    super.key,
    required this.active,
    required this.school,
  });

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160.w,
      margin: EdgeInsets.only(left: active ? 0 : 14.w),
      child: BouncingWidget(
        onTap: () => pushPage(
          context,
          to: SchoolScreen(school: school),
        ),
        child: Card(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5.r),
                child: CachedNetworkImage(
                  imageUrl: school.image,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 4.h, bottom: 4.h, left: 4.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        school.name.toUpperCase(),
                        maxLines: 2,
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_right_alt,
                      color: primaryColor,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
