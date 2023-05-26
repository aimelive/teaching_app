import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_connect_mobile/data/providers/class_services.dart';
import 'package:e_connect_mobile/ui/widgets/custom_circular_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swipe_image_gallery/swipe_image_gallery.dart';

import '../../../../utils/app_utils.dart';
import '../../../constants/colors.dart';
import '../../../helpers/ui_utils.dart';

class LessonsImages extends StatefulWidget {
  const LessonsImages({
    super.key,
    required this.images,
    required this.classId,
  });
  final List<String> images;
  final String classId;

  @override
  State<LessonsImages> createState() => _LessonsImagesState();
}

class _LessonsImagesState extends State<LessonsImages> {
  bool _loading = false;

  final _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        addVerticalSpace(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Lessons Files",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: primaryColor,
              ),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: TextButton.icon(
                icon: _loading
                    ? const CustomCircularProgressIndicator(
                        indicatorColor: primaryColor,
                        widthAndHeight: 15,
                      )
                    : const Icon(
                        Icons.add_circle_outline,
                        color: primaryColor,
                      ),
                onPressed: () async {
                  if (_loading) return;
                  final selectedImage =
                      await UiUtils.selectImage(context, mounted);
                  if (selectedImage == null || !mounted) return;

                  AppUtils().uploadFile(
                    context,
                    selectedImage.name,
                    File(selectedImage.path),
                    onLoading: (val) => setState(() => _loading = val),
                    onSuccess: (imgUrl) async {
                      setState(() => _loading = true);
                      final result = await ClassServices()
                          .addLessonPicture(widget.classId, imgUrl);
                      setState(() => _loading = false);
                      if (!mounted) return;
                      if (result == true) {
                        UiUtils.showMessage(
                          message: "Lesson picture added succesfully!",
                          title: "Class Updated",
                        );
                        popPage(context);
                        return;
                      }
                      UiUtils.showCustomSnackBar(
                        context: context,
                        errorMessage: result,
                        backgroundColor: Colors.red,
                      );
                    },
                  );
                },
                label: const Text(
                  "Add More",
                ),
              ),
            )
          ],
        ),
        addVerticalSpace(10),
        SizedBox(
          height: 140,
          child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                final image = widget.images[index];
                return GestureDetector(
                  onTap: () => SwipeImageGallery(
                    context: context,
                    children: [
                      CachedNetworkImage(imageUrl: image),
                    ],
                  ).show(),
                  child: Container(
                    margin: EdgeInsets.only(left: index == 0 ? 0 : 12.w),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(6.r),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(image),
                        fit: BoxFit.cover,
                      ),
                    ),
                    width: 150,
                  ),
                );
              }),
        ),
        addVerticalSpace(25),
      ],
    );
  }
}
