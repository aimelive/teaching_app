import 'package:e_connect_mobile/ui/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomTabBarContainer extends StatelessWidget {
  final BoxConstraints boxConstraints;
  final AlignmentGeometry alignment;
  final bool isSelected;
  final String titleKey;
  final Function onTap;
  const CustomTabBarContainer(
      {Key? key,
      required this.boxConstraints,
      required this.alignment,
      required this.isSelected,
      required this.onTap,
      required this.titleKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.transparent)),
          alignment: Alignment.center,
          height: boxConstraints.maxHeight * (0.325),
          width: boxConstraints.maxWidth * (0.375),
          child: AnimatedDefaultTextStyle(
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
              color: isSelected ? whiteColor : primaryColor,
            ),
            child: Text(
              titleKey,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
