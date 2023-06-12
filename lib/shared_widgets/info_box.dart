
import 'package:flutter/material.dart';
import 'package:team_finder/shared_widgets/edited_container.dart';

class InfoBox extends StatelessWidget {
  final String title;
  final Widget child;
  final EdgeInsets? margin;
  final EdgeInsets childPadding;
  final Color? headerColor;

  const InfoBox({
    Key? key,
    required this.title,
    required this.child,
    this.margin,
    this.childPadding = EdgeInsets.zero,
    this.headerColor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EditedContainer(
      margin: margin,
      shadowColor: Colors.grey[800]!,

      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            decoration: BoxDecoration(
              color: headerColor ?? Colors.cyan[800],
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10)
              )
            ),
            child: Text(
              title,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white
              ),
            ),
          ),

          Padding(
            padding: childPadding,
            child: child,
          ),
        ],
      ),
    );
  }
}


