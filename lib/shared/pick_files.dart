
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:team_finder/shared_widgets/edited_container.dart';

class PickImage {
  static Future<File?> pickImage(BuildContext context, void Function()? onDelete) async {
    File? pickedImage;
    bool pickingOff = true;

    await showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return pickingOff;
          },
          child: AlertDialog(
            contentPadding: EdgeInsets.zero,
            insetPadding: const EdgeInsets.symmetric(vertical: 70),
            clipBehavior: Clip.antiAlias,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),

            content: EditedContainer(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Center(
                    child: Text(
                      "UPLOAD IMAGE",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  ListTile(
                    title: const Text(
                      "From Gallery",
                      style: TextStyle(
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    leading: Icon(Icons.image, color: Colors.cyan[700]),
                    onTap: () async {
                      pickingOff = false;
                      NavigatorState navigator = Navigator.of(context);
                      pickedImage = await getImage(true);
                      navigator.pop();
                    },
                  ),

                  ListTile(
                    title: const Text(
                      "From Camera",
                      style: TextStyle(
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    leading: Icon(Icons.camera_alt, color: Colors.cyan[700]),
                    onTap: () async {
                      pickingOff = false;
                      NavigatorState navigator = Navigator.of(context);
                      pickedImage = await getImage(false);
                      navigator.pop();
                    },
                  ),

                  if (onDelete != null)
                    ...[
                      const Divider(),

                      ListTile(
                        title: const Text(
                          "Delete",
                          style: TextStyle(
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        leading: Icon(Icons.camera_alt, color: Colors.cyan[700]),
                        onTap: onDelete,
                      ),
                    ]
                ],
              ),
            ),

          ),
        );
      }
    );

    return pickedImage;
  }

  static Future<File?> getImage(bool fromGallery) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedImage = await imagePicker.pickImage(
      source: fromGallery? ImageSource.gallery: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800
    );

    return pickedImage != null? File(pickedImage.path): null;
  }
}


class PickFile {
  static Future<File?>? pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ["pdf"],
      type: FileType.custom
    );
    if (result == null) return null;
    String? filePath = result.files[0].path;
    return filePath == null? null: File(filePath);
  }
}
