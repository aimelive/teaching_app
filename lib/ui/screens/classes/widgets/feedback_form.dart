import 'package:e_connect_mobile/ui/constants/colors.dart';
import 'package:e_connect_mobile/ui/helpers/ui_utils.dart';
import 'package:e_connect_mobile/ui/widgets/custom_circular_progress.dart';
import 'package:e_connect_mobile/ui/widgets/rate_stars_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeedBackForm extends StatefulWidget {
  const FeedBackForm({super.key, required this.onClose});
  final VoidCallback onClose;

  @override
  State<FeedBackForm> createState() => _FeedBackFormState();
}

class _FeedBackFormState extends State<FeedBackForm> {
  int _rate = 0;
  final _cnt = TextEditingController();

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
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
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "@Aime Ndayambaje",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: " - Teacher Assistant",
                        style: TextStyle(color: Colors.black),
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
                onPressed: widget.onClose,
                child: const Text("Not Now"),
              ),
              ElevatedButton(
                onPressed: () async {
                  UiUtils.unfocus(context);
                  setState(() {
                    _isLoading = true;
                  });
                  await Future.delayed(const Duration(seconds: 2), () {
                    UiUtils.showMessage(
                      message:
                          "Your feedback to teacher assistant has sent to an admin successfully,",
                      title: "Feedback sent!",
                    );
                  });
                  setState(() {
                    _isLoading = false;
                  });
                  widget.onClose();
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
  }
}
