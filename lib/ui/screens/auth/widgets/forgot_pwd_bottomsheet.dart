import 'package:e_connect_mobile/ui/helpers/ui_utils.dart';
import 'package:e_connect_mobile/ui/widgets/bottomsheet_top_itle_close_button.dart';
import 'package:e_connect_mobile/ui/widgets/custom_button.dart';
import 'package:e_connect_mobile/ui/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPasswordRequestBottomsheet extends StatefulWidget {
  const ForgotPasswordRequestBottomsheet({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordRequestBottomsheet> createState() =>
      _ForgotPasswordRequestBottomsheetState();
}

class _ForgotPasswordRequestBottomsheetState
    extends State<ForgotPasswordRequestBottomsheet> {
  final TextEditingController _emailTextEditingController =
      TextEditingController();

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        // if (context.read<ForgotPasswordRequestCubit>().state
        //     is ForgotPasswordRequestInProgress) {
        //   return Future.value(false);
        // }
        return Future.value(true);
      },
      child: Container(
        margin: MediaQuery.of(context).viewInsets,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * (0.075),
            vertical: MediaQuery.of(context).size.height * (0.04)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BottomsheetTopTitleAndCloseButton(
                onTapCloseButton: () {
                  // if (context.read<ForgotPasswordRequestCubit>().state
                  //     is ForgotPasswordRequestInProgress) {
                  //   return;
                  // }
                  Navigator.of(context).pop();
                },
                titleKey: "Forgot Password",
              ),
              CustomTextFieldContainer(
                hideText: false,
                hintText: "Email",
                textEditingController: _emailTextEditingController,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * (0.025),
              ),
              CustomRoundedButton(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    if (_emailTextEditingController.text.trim().isEmpty) {
                      UiUtils.showCustomSnackBar(
                        context: context,
                        errorMessage: "Please enter your email",
                        backgroundColor: Theme.of(context).colorScheme.error,
                      );
                      return;
                    }
                  },
                  height: 40,
                  textSize: 16.0,
                  widthPercentage: 0.45,
                  titleColor: Theme.of(context).scaffoldBackgroundColor,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  buttonTitle: "Submit",
                  // buttonTitle: UiUtils.getTranslatedLabel(
                  //     context,
                  //     state is ForgotPasswordRequestInProgress
                  //         ? submittingKey
                  //         : submitKey),
                  showBorder: false)
            ],
          ),
        ),
      ),
    );
  }
}
