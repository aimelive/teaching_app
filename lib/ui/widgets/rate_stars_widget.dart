import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RateStarsWidget extends StatelessWidget {
  const RateStarsWidget({
    super.key,
    this.value = 0,
    this.onClick,
    this.size=20,
  });
  final int value;
  final double size;
  final void Function(int value)? onClick;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [1, 2, 3, 4, 5]
          .map(
            (rate) => GestureDetector(
              onTap: () {
                onClick == null ? null : onClick!(rate);
              },
              child: Icon(
                Icons.star,
                size: size.sp,
                color: rate <= value
                    ? Colors.amber.shade700
                    : Colors.grey.shade500,
              ),
            ),
          )
          .toList(),
    );
  }
}
