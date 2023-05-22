import 'package:e_connect_mobile/ui/constants/colors.dart';
import 'package:flutter/material.dart';

class TabBarBackgroundContainer extends StatelessWidget {
  final BoxConstraints boxConstraints;
  const TabBarBackgroundContainer({Key? key, required this.boxConstraints})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor),
        borderRadius: BorderRadius.circular(15.0),
      ),
      height: boxConstraints.maxHeight,
      width: boxConstraints.maxWidth * (0.35),
      child: Container(
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
