
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:team_finder/shared_widgets/circle_image.dart';

class CircleImageWithButton extends StatelessWidget {
  final double radius;
  final String? asset;
  final String? network;
  final File? file;
  final Color borderColor;
  final double borderWidth;
  final Widget? placeHolder;
  final EdgeInsets? margin;
  final void Function()? onPress;

  const CircleImageWithButton({
    Key? key,
    required this.radius,
    this.asset,
    this.network,
    this.file,
    this.borderColor = Colors.black,
    this.borderWidth = 2,
    this.placeHolder,
    this.margin,
    this.onPress
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleImage(
          radius: radius,
          asset: asset,
          network: network,
          file: file,
          borderColor: borderColor,
          borderWidth: borderWidth,
          placeHolder: placeHolder,
          margin: margin,
        ),

        Positioned(
          right: 8,
          bottom: 8,
          child: CircleAvatar(
            radius: 23,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.black,
              child: IconButton(
                  onPressed: onPress,
                  icon: const Icon(Icons.add_a_photo, color: Colors.white)
              ),
            ),
          ),
        )
      ],
    );
  }
}


