import 'package:flutter/material.dart';

class BouncingWidget extends StatefulWidget {
  const BouncingWidget({
    Key? key,
    required this.child,
    required this.onTap,
  }) : super(key: key);
  final Widget child;
  final VoidCallback onTap;
  @override
  BouncingWidgetState createState() => BouncingWidgetState();
}

class BouncingWidgetState extends State<BouncingWidget>
    with SingleTickerProviderStateMixin {
  int duration = 150;
  late double _scale;
  late AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: duration,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return GestureDetector(
      onTapDown: (details) {
        _controller.forward();
      },
      onTapUp: (details) async {
        await Future.delayed(Duration(milliseconds: duration));
        _controller.reverse();
      },
      onTap: () async {
        await Future.delayed(Duration(milliseconds: duration * 2));
        widget.onTap();
      },
      child: Transform.scale(
        scale: _scale,
        child: widget.child,
      ),
    );
  }
}
