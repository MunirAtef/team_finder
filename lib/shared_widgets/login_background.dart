
import 'package:flutter/material.dart';

class LoginBackground extends StatelessWidget {
  const LoginBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return OverflowBox(
      maxHeight: height,
      maxWidth: width,
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            width: width,
            child: Image.asset(
              "assets/images/register_bg_up.png",
              height: height * 2 / 5,
            )
          ),

          const Expanded(child: SizedBox()),

          Container(
            alignment: Alignment.bottomRight,
            width: width,
            child: Image.asset(
              "assets/images/register_bg_down.png",
              height: height * 2 / 5
            )
          ),
        ],
      ),
    );
  }
}


