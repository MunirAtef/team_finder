
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:team_finder/screens/profile/profile_ui.dart';
import 'package:team_finder/shared_widgets/edited_button.dart';
import 'package:team_finder/shared_widgets/edited_container.dart';
import 'package:team_finder/shared_widgets/edited_text_field.dart';


class AddLink extends StatefulWidget {
  final Future<bool> Function(String? type, String? title, String url)? onLinkAdded;
  const AddLink({Key? key, this.onLinkAdded}) : super(key: key);

  @override
  State<AddLink> createState() => _AddLinkState();
}

class _AddLinkState extends State<AddLink> {
  String? selectedUrlType;
  List<String> linksNames = linksIcons.keys.toList()..add("Other");
  TextEditingController urlController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  bool isLoading = false;


  Icon getUrlIcon(String title) {
    IconData iconData = linksIcons[title]?.icon ?? FontAwesomeIcons.link;
    return Icon(iconData, color: Colors.cyan[700]);
  }

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
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        content: SingleChildScrollView(
          child: EditedContainer(
            padding: const EdgeInsets.only(top: 20),
            width: width - 70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "ADD LINK",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20
                  ),
                ),

                EditedContainer(
                  height: 55,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  width: double.infinity,
                  backgroundColor: Colors.grey[900]!,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10)
                  ),

                  child: DropdownButton<String>(
                    value: selectedUrlType,
                    dropdownColor: Colors.grey[800],
                    hint: Text(
                      "Choose Link Type",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[400]
                      ),
                    ),
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white
                    ),
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down, size: 30, color: Colors.white),
                    onChanged: (String? newValue) {
                      setState(() { selectedUrlType = newValue!; });
                    },
                    items: linksNames.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),

                Visibility(
                  visible: selectedUrlType == "Other",
                  child: EditedTextField(
                    controller: titleController,
                    hint: "Link Title",
                    prefix: Icon(Icons.title, color: Colors.cyan[700]),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    borderRadius: const BorderRadius.all(Radius.zero),
                  ),
                ),

                EditedTextField(
                  controller: urlController,
                  hint: "URL",
                  prefix: getUrlIcon(selectedUrlType ?? "Other"),
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10)
                  ),
                ),

                EditedButton(
                  leading: const Icon(Icons.add_link, color: Colors.white),
                  text: "ADD LINK",
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  onPressed: () async {
                    NavigatorState navigator = Navigator.of(context);
                    setState(() { isLoading = true; });
                    bool result = await widget.onLinkAdded!(
                      selectedUrlType,
                      titleController.text.trim(),
                      urlController.text.trim()
                    );
                    setState(() { isLoading = false; });
                    if (result == true) navigator.pop();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}





