import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_connect_mobile/data/models/user.dart';
import 'package:e_connect_mobile/data/providers/stream_provider.dart';
import 'package:e_connect_mobile/ui/helpers/keyboard_visible.dart';
import 'package:e_connect_mobile/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/colors.dart';
import '../../../helpers/ui_utils.dart';
import '../../../widgets/custom_circular_progress.dart';
import '../../../widgets/rate_stars_widget.dart';

class ClassAssistantWidget extends StatefulWidget {
  const ClassAssistantWidget({
    super.key,
    required this.classId,
    required this.trAssistantId,
  });
  final String classId;
  final String trAssistantId;

  @override
  State<ClassAssistantWidget> createState() => _ClassAssistantWidgetState();
}

class _ClassAssistantWidgetState extends State<ClassAssistantWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        addVerticalSpace(20),
        Text(
          "Class Assistant",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: primaryColor,
          ),
        ),
        addVerticalSpace(5),
        StreamProvider<UserAccount>(
          collectionId: Collection.userCollectionId,
          docId: widget.trAssistantId,
          fromJson: (json) => UserAccount.fromJson(json),
          loading: const Text("Getting teacher assistant info. please wait!"),
          onError: (error) => Text(error),
          onSuccess: (user) {
            return FeedBackForm(
              user: user,
              classId: widget.classId,
            );
          },
        ),
        addVerticalSpace(15),
      ],
    );
  }
}

class FeedBackForm extends StatefulWidget {
  const FeedBackForm({
    super.key,
    required this.user,
    required this.classId,
  });
  final UserAccount user;
  final String classId;

  @override
  State<FeedBackForm> createState() => _FeedBackFormState();
}

class _FeedBackFormState extends State<FeedBackForm> {
  int _rate = 0;
  final _cnt = TextEditingController();

  bool _isLoading = false;
  bool _showFeebackForm = false;

  final _appUtils = AppUtils();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            radius: 25.r,
            foregroundImage: CachedNetworkImageProvider(widget.user.profilePic),
          ),
          title: Text(widget.user.names),
          subtitle: Text(widget.user.role.name),
          trailing: GestureDetector(
            onTap: () => setState(() => _showFeebackForm = !_showFeebackForm),
            child: Icon(
              Icons.forum_outlined,
              color: _showFeebackForm ? primaryColor : null,
            ),
          ),
        ),
        if (_showFeebackForm)
          CustomKeyboardVisibleWidget(builder: (_, bottom) {
            return Container(
              margin: EdgeInsets.only(bottom: bottom),
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: secondaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Rate:",
                    style: TextStyle(fontSize: 18.sp),
                  ),
                  addVerticalSpace(5),
                  RateStarsWidget(
                    value: _rate,
                    size: 30,
                    onClick: (value) {
                      setState(() => _rate = value);
                    },
                  ),
                  addVerticalSpace(15),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "@${widget.user.names}",
                                style: const TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: " - ${widget.user.role.name}",
                                style: const TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        addVerticalSpace(10),
                        TextField(
                          controller: _cnt,
                          minLines: 5,
                          maxLines: 90,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                            border: InputBorder.none,
                            hintText: "Provide your feedback here.",
                          ),
                        ),
                      ],
                    ),
                  ),
                  addVerticalSpace(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () =>
                            setState(() => _showFeebackForm = false),
                        child: const Text("Not Now"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_cnt.text.trim().isEmpty || _isLoading) return;
                          final added = await _appUtils.addFeedback(
                            context,
                            mounted,
                            classId: widget.classId,
                            feedback: _cnt.text.trim(),
                            rate: _rate,
                            onLoading: (val) =>
                                setState(() => _isLoading = val),
                          );
                          if (!added) return;
                          setState(() {
                            _showFeebackForm = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          shadowColor: Colors.transparent,
                          shape: const StadiumBorder(),
                        ),
                        child: _isLoading
                            ? const CustomCircularProgressIndicator(
                                widthAndHeight: 20,
                              )
                            : const Text("Submit"),
                      ),
                    ],
                  )
                ],
              ),
            );
          })
      ],
    );
  }
}
