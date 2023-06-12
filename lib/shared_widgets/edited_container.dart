
import 'package:flutter/material.dart';

class EditedContainer extends StatelessWidget {
  final Color shadowColor;
  final Color backgroundColor;
  final double? width;
  final double? height;
  final double? maxWidth;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Widget? child;
  final BorderRadiusGeometry? borderRadius;

  const EditedContainer({
    Key? key,
    this.shadowColor = Colors.black,
    this.backgroundColor = Colors.white,
    this.width,
    this.height,
    this.maxWidth,
    this.margin,
    this.padding,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,

      constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: Border.all(color: Colors.black),
        boxShadow: [
          BoxShadow(
            color: shadowColor
          ),
          BoxShadow(
            color: backgroundColor,
            blurRadius: 8,
            spreadRadius: -4
          ),
        ]
      ),

      child: child
    );
  }
}
