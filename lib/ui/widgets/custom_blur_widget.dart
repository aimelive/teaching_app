import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomBlurWidget extends StatelessWidget {
  const CustomBlurWidget({
    super.key,
    required this.child,
    this.height,
    required this.imgUrl,
    this.width,
    this.blur,
  });

  final Widget child;
  final String imgUrl;
  final double? width;
  final double? height;
  final double? blur;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        image: DecorationImage(
          image: CachedNetworkImageProvider(
            imgUrl,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur ?? 2, sigmaY: blur ?? 2),
          child: child,
        ),
      ),
    );
  }
}
