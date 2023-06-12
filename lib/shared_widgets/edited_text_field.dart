
import 'package:flutter/material.dart';

class EditedTextField extends StatelessWidget {
  final TextEditingController? controller;
  final EdgeInsets? margin;
  final double minHeight;
  final double maxHeight;
  final String hint;
  final int maxLines;
  final Widget? prefix;
  final Widget? suffix;
  final String? prefixText;
  final BorderRadius? borderRadius;
  final bool isReadOnly;
  final bool autoFocus;
  final bool hideText;

  const EditedTextField({
    Key? key,
    this.controller,
    this.margin,
    this.minHeight = 60,
    this.maxHeight = 60,
    required this.hint,
    this.maxLines = 1,
    this.prefix,
    this.suffix,
    this.prefixText,
    this.borderRadius,
    this.isReadOnly = false,
    this.autoFocus = false,
    this.hideText = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      constraints: BoxConstraints(
        minHeight: minHeight,
        maxHeight: maxHeight
      ),
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? const BorderRadius.all(Radius.circular(10)),

        boxShadow: [
          BoxShadow(
            color: Colors.grey[700]!
          ),
          const BoxShadow(
            color: Colors.white,
            blurRadius: 12,
            spreadRadius: -2
          ),
        ]
      ),
      child: TextField(
        controller: controller,
        cursorColor: Colors.cyan,
        textInputAction: maxLines == 1? TextInputAction.done: TextInputAction.newline,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isReadOnly? Colors.red[700] : Colors.grey[800]
        ),
        textAlignVertical: TextAlignVertical(y: maxHeight < 53? 1: 0.6),
        minLines: 1,
        maxLines: maxLines,
        readOnly: isReadOnly,
        autofocus: autoFocus,
        obscureText: hideText,

        decoration: InputDecoration(
          suffixIcon: suffix,
          prefixIcon: prefix ?? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CircleAvatar(
              radius: 12,
              backgroundColor: Colors.cyan[700],
              child: prefixText != null? Text(
                prefixText!,
                style: const TextStyle(
                  fontSize: 6,
                  fontWeight: FontWeight.w600,
                  color: Colors.white
                ),
              ) : null,
            ),
          ),

          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey[600],
            backgroundColor: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600
          ),
          border: OutlineInputBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(10)
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.cyan, width: 2)
          ),
        ),
      ),
    );
  }
}

