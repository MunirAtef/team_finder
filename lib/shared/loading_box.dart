
import 'package:flutter/material.dart';
import 'package:team_finder/shared_widgets/edited_container.dart';


showLoading({
  String title = "LOADING...",
  required BuildContext context,
  required Future<void> Function() waitFor
}) {
  showDialog(
    context: context,
    builder: (context) => LoadingBox(waitFor: waitFor, title: title)
  );
}


class LoadingBox extends StatelessWidget {
  final Future<void> Function() waitFor;
  final String title;
  const LoadingBox({Key? key, required this.waitFor, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    Future.delayed(Duration.zero, () async {
      NavigatorState navigator = Navigator.of(context);
      await waitFor();
      navigator.pop();
    });

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AlertDialog(
        contentPadding: EdgeInsets.zero,
        insetPadding: const EdgeInsets.symmetric(vertical: 70),
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),

        content: EditedContainer(
          width: width - 80,
          height: 150,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600
                ),
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
