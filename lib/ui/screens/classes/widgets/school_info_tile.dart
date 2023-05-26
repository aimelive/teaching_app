import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_connect_mobile/data/models/school.dart';
import 'package:e_connect_mobile/ui/constants/colors.dart';
import 'package:e_connect_mobile/ui/helpers/ui_utils.dart';
import 'package:e_connect_mobile/ui/screens/school/school.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SchoolInfoTile extends StatelessWidget {
  const SchoolInfoTile({
    super.key,
    required this.school,
    required this.room,
  });

  final School school;
  final String room;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: CachedNetworkImage(
            imageUrl: school.image,
            height: 80,
            width: 100,
            fit: BoxFit.cover,
          ),
        ),
        addHorizontalSpace(10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                school.name,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 16.sp,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w600,
                ),
              ),
              addVerticalSpace(5),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 12.sp,
                    color: primaryColor,
                  ),
                  Expanded(
                    child: Text(
                      school.address.location,
                      maxLines: 1,
                      style: const TextStyle(
                        color: primaryColor,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              addVerticalSpace(5),
              Text(
                "Room: $room",
                maxLines: 1,
                style: const TextStyle(
                  color: secondaryColor,
                ),
              ),
            ],
          ),
        ),
        addHorizontalSpace(10),
        InkWell(
          onTap: () => pushPage(
            context,
            to: SchoolScreen(school: school),
          ),
          borderRadius: BorderRadius.circular(8.r),
          child: Ink(
            padding: EdgeInsets.all(10.r),
            child: SvgPicture.asset(
              getIconPath('link'),
              // ignore: deprecated_member_use
              color: primaryColor,
            ),
          ),
        )
      ],
    );
  }
}
