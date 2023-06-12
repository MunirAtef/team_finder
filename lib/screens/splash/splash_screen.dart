
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:team_finder/screens/login/login_ui.dart';
import 'package:team_finder/screens/routes_holder/routes_holder_ui.dart';
import 'package:team_finder/shared/user_data.dart';
import 'package:team_finder/shared_widgets/edited_container.dart';
import 'package:animated_text_kit/animated_text_kit.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      NavigatorState navigator = Navigator.of(context);

      await Future.delayed(const Duration(seconds: 3));

      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        await Future.delayed(const Duration(seconds: 3));
        navigator.pushReplacement(
            MaterialPageRoute(builder: (context) => const Login())
        );
        return;
      }
      UserData.uid = user.uid;
      await UserData.getData();

      navigator.pushReplacement(
          MaterialPageRoute(builder: (context) => const RoutesHolder())
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: height / 6),

            EditedContainer(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(70),
              shadowColor: Colors.grey[600]!,
              child: Image.asset("assets/images/team_finder_icon.png"),
            ),

            const Text(
              "DEVELOPED BY",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.purple
              )
            ),

            EditedContainer(
              height: 70,
              width: double.infinity,
              shadowColor: Colors.grey[600]!,
              margin: const EdgeInsets.symmetric(horizontal: 70),

              child: Center(
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      "MUNIR M. ATEF",
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyan[800]
                      ),
                      speed: const Duration(milliseconds: 200),
                    ),
                  ],

                  totalRepeatCount: 50,
                  pause: const Duration(milliseconds: 500),
                  displayFullTextOnTap: true,
                  stopPauseOnTap: true,
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}

