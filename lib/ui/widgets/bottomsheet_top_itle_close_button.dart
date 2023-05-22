import 'package:e_connect_mobile/ui/widgets/custom_close_button.dart';
import 'package:flutter/material.dart';

class BottomsheetTopTitleAndCloseButton extends StatelessWidget {
  final String titleKey;
  final Function onTapCloseButton;
  const BottomsheetTopTitleAndCloseButton(
      {Key? key, required this.onTapCloseButton, required this.titleKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titleKey,
              style: TextStyle(
                  fontSize: 16.0,
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            CustomCloseButton(
              onTapCloseButton: onTapCloseButton,
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Divider(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * (0.0075),
        ),
      ],
    );
  }
}
