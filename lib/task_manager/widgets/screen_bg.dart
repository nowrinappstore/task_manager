import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager/task_manager/utils/asset_path.dart';

class ScreenBG extends StatelessWidget {
  final Widget child;

  const ScreenBG({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset(
          AssetPath.bgSVG,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
        child,
      ],
    );
  }
}