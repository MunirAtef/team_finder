
import 'package:flutter/material.dart';
import 'package:team_finder/shared_widgets/edited_button.dart';
import 'package:team_finder/shared_widgets/edited_container.dart';


class ConfirmMessage extends StatefulWidget {
  final String title;
  final String? content;
  final Future<void> Function()? onConfirm;

  const ConfirmMessage({
    super.key,
    required this.title,
    this.content,
    this.onConfirm
  });

  @override
  State<ConfirmMessage> createState() => _ConfirmMessageState();
}

class _ConfirmMessageState extends State<ConfirmMessage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        return !isLoading;
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
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 19
                ),
              ),

              if (widget.content != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    widget.content!,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15
                    ),
                  ),
                ),

              EditedButton(
                text: "CONFIRM",
                isLoading: isLoading,
                margin: const EdgeInsets.only(top: 15, bottom: 20),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                onPressed: () async {
                  if (widget.onConfirm == null) return;
                  NavigatorState navigator = Navigator.of(context);
                  setState(() { isLoading = true; });
                  await widget.onConfirm!();
                  navigator.pop();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}



