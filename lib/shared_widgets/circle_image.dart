
import 'dart:io';
import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {
  final double radius;
  final String? asset;
  final String? network;
  final File? file;
  final Color borderColor;
  final double borderWidth;
  final Widget? placeHolder;
  final EdgeInsets? margin;

  const CircleImage({
    Key? key,
    required this.radius,
    this.asset,
    this.network,
    this.file,
    this.borderColor = Colors.black,
    this.borderWidth = 2,
    this.placeHolder,
    this.margin
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ImageProvider? image;
    if (asset != null) {
      image = AssetImage(asset!);
    } else if (network != null) {
      image = NetworkImage(network!);
    } else if (file != null) {
      image = FileImage(file!);
    }

    return Container(
      width: radius * 2,
      height: radius * 2,
      margin: margin,
      decoration: BoxDecoration(
        image: image != null? DecorationImage(
          image: image,
          fit: BoxFit.cover
        ) : null,
        shape: BoxShape.circle,
        border: Border.all(width: borderWidth, color: borderColor)
      ),
      child: image == null? placeHolder : null,
    );
  }
}

