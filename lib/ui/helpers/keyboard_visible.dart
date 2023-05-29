import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class CustomKeyboardVisibleWidget extends StatelessWidget {
  const CustomKeyboardVisibleWidget({
    super.key,
    required this.builder,
  });
  final Widget Function(bool isVisible, double bottom) builder;

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (_, isVisible) {
      final viewInsets = EdgeInsets.fromViewPadding(
        View.of(context).viewInsets,
        View.of(context).devicePixelRatio,
      );
      return builder(isVisible, viewInsets.bottom);
    });
  }
}
