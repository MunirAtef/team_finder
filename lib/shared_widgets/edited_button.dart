
import 'package:flutter/material.dart';

class EditedButton extends StatelessWidget {
  final Color color;
  final void Function()? onPressed;
  final String text;
  final Widget? leading;
  final double width;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final bool isLoading;
  final BorderRadius? borderRadius;

  const EditedButton({
    super.key,
    this.color = Colors.cyan,
    this.text = "",
    this.leading,
    this.width = double.infinity,
    this.padding = const EdgeInsets.symmetric(horizontal: 40),
    this.margin = const EdgeInsets.only(top: 10, bottom: 20),
    this.isLoading = false,
    this.borderRadius,
    required this.onPressed
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding,
      margin: margin,
      child: OutlinedButton(
        onPressed: isLoading? null: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            width: 2,
            color: Colors.white
          ),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(30)
          ),
          backgroundColor: isLoading? Colors.grey: color,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          elevation: 8
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 35,
              height: 35,
              child: isLoading? const Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(color: Colors.white),
              ) : leading
            ),

            Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.white
              ),
            ),

            const SizedBox(width: 40)
          ],
        ),
      ),
    );
  }
}

