import 'package:flutter/material.dart';

class TopBarIcon extends StatelessWidget {
  final IconData icon;
  final double width;
  final onPressedFunction;
  final buttonColor;
  final double size;
  final bool removePadding;
  TopBarIcon({
    @required this.icon,
    this.width,
    this.onPressedFunction,
    this.buttonColor,
    this.size,
    this.removePadding = false,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressedFunction,
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(
            vertical: removePadding ? 0 : 5,
            horizontal: removePadding ? 0 : 10),
        child: Icon(
          icon,
          size: size ?? 25,
          color: buttonColor ?? Colors.grey[700],
        ),
      ),
    );
  }
}
