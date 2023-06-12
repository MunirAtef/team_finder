
import 'package:flutter/material.dart';

class GradiantDivider extends StatelessWidget {
  const GradiantDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.cyan[700]!,
              Colors.purple,
              Colors.cyan[700]!,
            ],
            stops: const [0, 0.5, 1],
          ),
          borderRadius: const BorderRadius.all(Radius.circular(3))
      ),
    );
  }
}

