
import 'package:flutter/material.dart';
import 'package:team_finder/shared_widgets/edited_button.dart';
import 'package:team_finder/shared_widgets/edited_container.dart';
import 'package:team_finder/shared_widgets/edited_text_field.dart';

class InputDialog extends StatefulWidget {
  final String title;
  final String hint;
  final bool multiLine;
  final Icon? prefix;
  final Future<bool> Function(String textFieldValue)? onConfirm;

  const InputDialog({
    super.key,
    required this.title,
    required this.hint,
    this.multiLine = false,
    this.prefix,
    this.onConfirm
  });

  @override
  State<InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  bool isLoading = false;
  TextEditingController textFieldController = TextEditingController();

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

              EditedTextField(
                controller: textFieldController,
                hint: widget.hint,
                prefix: widget.prefix,
                margin: const EdgeInsets.only(top: 15),
                maxHeight: widget.multiLine? 100 : 60,
                maxLines: widget.multiLine? 3 : 1,
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
                  bool result = await widget.onConfirm!(textFieldController.text);
                  setState(() { isLoading = false; });
                  if (result) navigator.pop();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}









