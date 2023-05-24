import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_connect_mobile/ui/constants/colors.dart';
import 'package:e_connect_mobile/ui/helpers/ui_utils.dart';
import 'package:e_connect_mobile/ui/widgets/custom_circular_progress.dart';
import 'package:e_connect_mobile/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class InputContainer extends StatefulWidget {
  const InputContainer({super.key, required this.onSend});
  final void Function(String message, String? image) onSend;

  @override
  State<InputContainer> createState() => _InputContainerState();
}

class _InputContainerState extends State<InputContainer> {
  final _radius = BorderRadius.circular(25.r);
  final TextEditingController _textEditingController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  String? uploadedImage;
  Uint8List? currentlyUploading;

  Future<XFile?> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
      );
      if (image == null) return null;
      return image;
    } catch (e) {
      UiUtils.showCustomSnackBar(
        context: context,
        errorMessage: e.toString(),
        backgroundColor: Colors.red,
      );
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        // color: lightPrimary.withOpacity(0.1),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () async {
                final source = await showDialog<ImageSource>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [ImageSource.camera, ImageSource.gallery]
                              .map(
                                (source) => ListTile(
                                  onTap: () => popPage(context, data: source),
                                  leading: Icon(source == ImageSource.camera
                                      ? Icons.photo_camera_outlined
                                      : Icons.photo_outlined),
                                  title: Text(
                                    source == ImageSource.camera
                                        ? "Take a photo"
                                        : "Choose From Gallery",
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      );
                    });
                if (source == null) return;
                final selectedImage = await _pickImage(source);
                if (selectedImage == null || !mounted) return;
                final bytes = await selectedImage.readAsBytes();
                setState(() {
                  currentlyUploading = bytes;
                });
                if (!mounted) return;
                await AppUtils().uploadFile(
                    context, selectedImage.name, File(selectedImage.path),
                    onLoading: (val) {
                  setState(() {
                    _isUploading = val;
                  });
                }, onSuccess: (img) {
                  setState(() {
                    uploadedImage = img;
                  });
                });
              },
              child: CircleAvatar(
                backgroundColor: secondaryColor.withOpacity(0.1),
                radius: 22.r,
                child: Icon(
                  Icons.add,
                  size: 22.sp,
                  color: primaryColor,
                ),
              ),
            ),
            addHorizontalSpace(10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    child: Row(
                      children: [
                        if (_isUploading && currentlyUploading != null)
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(5.r),
                              image: DecorationImage(
                                image: MemoryImage(currentlyUploading!),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: const CustomCircularProgressIndicator(),
                          ),
                        if (uploadedImage != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5.r),
                            child: CachedNetworkImage(
                              imageUrl: uploadedImage!,
                              height: 80,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: _radius,
                      color: secondaryColor.withOpacity(0.1),
                    ),
                    child: TextField(
                      controller: _textEditingController,
                      cursorColor: secondaryColor,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 8,
                      decoration: InputDecoration(
                        isDense: true,
                        hintStyle: const TextStyle(color: primaryColor),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 15.h,
                        ),
                        hintText: "Send a message",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            addHorizontalSpace(10),
            InkWell(
              borderRadius: _radius,
              onTap: () {
                FocusScope.of(context).unfocus();
                if (_textEditingController.text.trim().isEmpty) return;
                if (_isUploading) return;
                widget.onSend(
                    _textEditingController.text.trim(), uploadedImage);
                _textEditingController.clear();
                setState(() {
                  uploadedImage = null;
                });
              },
              child: Ink(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: secondaryColor.withOpacity(0.1),
                  borderRadius: _radius,
                ),
                child: Transform.rotate(
                  angle: 100,
                  child: SvgPicture.asset(
                    getIconPath("send"),
                    color: primaryColor,
                  ),
                ),
                // child: Row(
                //   children: [
                //     const Text(
                //       " Send",
                //       style: TextStyle(
                //         color: primaryColor,
                //         fontWeight: FontWeight.w600,
                //       ),
                //     ),
                //     addHorizontalSpace(7),
                //     Icon(
                //       Icons.send,
                //       size: 20.sp,
                //       color: primaryColor,
                //     ),
                //   ],
                // ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
