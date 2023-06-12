
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:team_finder/firebase/storage.dart';
import 'package:team_finder/general/open_pdf.dart';
import 'package:team_finder/models/contact.dart';
import 'package:team_finder/models/user_model.dart';
import 'package:team_finder/screens/chat_users/chat_users_ui.dart';
import 'package:team_finder/shared/add_link.dart';
import 'package:team_finder/shared/confirm_message.dart';
import 'package:team_finder/shared/input_dialog.dart';
import 'package:team_finder/shared/pick_files.dart';
import 'package:team_finder/shared/user_data.dart';
import 'package:team_finder/models/link_model.dart' as link_model;
import 'package:team_finder/shared/webview.dart';
import 'package:url_launcher/url_launcher.dart';


class ProfileCubit extends Cubit<UserModel> {
  BuildContext context;
  UserModel userModel;
  ProfileCubit(this.userModel, this.context): super(userModel);

  void setInitial(UserModel personModel, BuildContext context) {
    emit(personModel);
    this.context = context;
  }

  Future<void> updateName() async {
    Navigator.of(context).pop();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return InputDialog(
            title: "UPDATE YOUR NAME",
            hint: "Enter new name",
            onConfirm: (String newName) async {
              String name = newName.trim();
              if (name.length < 4) {
                Fluttertoast.showToast(msg: "Too short name");
                return false;
              }
              DocumentReference<Map<String, dynamic>> documentRef
              = FirebaseFirestore.instance.collection('users').doc(UserData.uid);

              await documentRef.update({"name": name});
              UserData.userModel.name = name;
              emit(UserData.userModel.clone());
              return true;
            },
          );
        }
      )
    );
  }

  Future<void> updateBio() async {
    Navigator.of(context).pop();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return InputDialog(
            title: "UPDATE YOUR BIO",
            hint: "Enter new bio",
            onConfirm: (String newBio) async {
              String bio = newBio.trim();
              if (bio.isEmpty) {
                Fluttertoast.showToast(msg: "No bio entered");
                return false;
              }
              DocumentReference<Map<String, dynamic>> documentRef
              = FirebaseFirestore.instance.collection('users').doc(UserData.uid);

              await documentRef.update({"bio": bio});
              UserData.userModel.bio = bio;
              emit(UserData.userModel.clone());
              return true;
            },
          );
        }
      )
    );
  }

  Future<void> deleteBio() async {
    Navigator.of(context).pop();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return ConfirmMessage(
            title: "DELETE BIO SECTION",
            content: "Are you sure you want to delete your bio",
            onConfirm: () async {
              DocumentReference<Map<String, dynamic>> documentRef
              = FirebaseFirestore.instance.collection('users').doc(UserData.uid);

              await documentRef.update({"bio": FieldValue.delete()});
              UserData.userModel.bio = null;
              emit(UserData.userModel.clone());
            },
          );
        }
      )
    );
  }


  Future<void> updateAbout() async {
    Navigator.of(context).pop();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return InputDialog(
            title: "UPDATE YOUR ABOUT",
            hint: "Enter new about",
            multiLine: true,
            onConfirm: (String newAbout) async {
              String about = newAbout.trim();
              if (about.isEmpty) {
                Fluttertoast.showToast(msg: "No about entered");
                return false;
              }
              DocumentReference<Map<String, dynamic>> documentRef
              = FirebaseFirestore.instance.collection('users').doc(UserData.uid);

              await documentRef.update({"about": about});
              UserData.userModel.about = about;
              emit(UserData.userModel.clone());
              return true;
            },
          );
        }
      )
    );
  }

  Future<void> deleteAbout() async {
    Navigator.of(context).pop();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return ConfirmMessage(
            title: "DELETE ABOUT SECTION",
            content: "Are you sure you want to delete about section",
            onConfirm: () async {
              DocumentReference<Map<String, dynamic>> documentRef
              = FirebaseFirestore.instance.collection('users').doc(UserData.uid);

              await documentRef.update({"about": FieldValue.delete()});
              UserData.userModel.about = null;
              emit(UserData.userModel.clone());
            },
          );
        }
      )
    );
  }


  Future<void> uploadProfilePicture() async {
    Navigator.of(context).pop();
    File? image = await PickImage.pickImage(context, null);
    if (image == null) return;

    /// upload image to firebase storage
    String? imageUrl = await Storage.uploadFile(
      path: 'users/${UserData.uid}/profileImage',
      file: image
    );

    /// update image url in firebase firestore
    DocumentReference<Map<String, dynamic>> documentRef
    = FirebaseFirestore.instance.collection('users').doc(UserData.uid);

    await documentRef.update({"imageUrl": imageUrl});
    UserData.userModel.imageUrl = imageUrl;
    emit(UserData.userModel.clone());
  }

  Future<void> deleteProfilePicture() async {
    Navigator.of(context).pop();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return ConfirmMessage(
            title: "DELETE PROFILE PICTURE",
            content: "Are you sure you want to delete profile picture",
            onConfirm: () async {
              DocumentReference<Map<String, dynamic>> documentRef
              = FirebaseFirestore.instance.collection('users').doc(UserData.uid);

              await documentRef.update({"imageUrl": FieldValue.delete()});
              UserData.userModel.imageUrl = null;
              emit(UserData.userModel.clone());
            },
          );
        }
      )
    );
  }


  Future<void> uploadCV() async {
    Navigator.of(context).pop();

    File? pdf = await PickFile.pickPdf();
    if (pdf == null) return;

    if (pdf.statSync().size > 5 * 8 * 1024 * 1024) {
      Fluttertoast.showToast(msg: "File cannot be more than 5 MB");
      return;
    }

    /// upload cv to firebase storage
    Reference storageReference = FirebaseStorage.instance.ref()
      .child('users/${UserData.uid}/CV.pdf');

    TaskSnapshot uploadTask = await storageReference.putFile(pdf);
    String cvLink = await uploadTask.ref.getDownloadURL();

    /// update image url in firebase firestore
    DocumentReference<Map<String, dynamic>> documentRef
      = FirebaseFirestore.instance.collection('users').doc(UserData.uid);

    await documentRef.update({"cvLink": cvLink});
    UserData.userModel.cvLink = cvLink;
    emit(UserData.userModel.clone());
  }


  Future<void> deleteCV() async {
    Navigator.of(context).pop();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return ConfirmMessage(
            title: "DELETE CV",
            content: "Are you sure you want to delete your cv",
            onConfirm: () async {
              DocumentReference<Map<String, dynamic>> documentRef
              = FirebaseFirestore.instance.collection('users').doc(UserData.uid);

              await documentRef.update({"cvLink": FieldValue.delete()});
              UserData.userModel.cvLink = null;
              emit(UserData.userModel.clone());
            },
          );
        }
      )
    );
  }


  void chooseLinkType() {
    Navigator.of(context).pop();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AddLink(onLinkAdded: onLinkAdded);
        }
      )
    );
  }

  Future<bool> onLinkAdded(String? type, String? title, String url) async {
    if (type == null) {
      Fluttertoast.showToast(msg: "Select URL type first");
      return false;
    }
    if (url == "") {
      Fluttertoast.showToast(msg: "Enter URL first");
      return false;
    }

    String urlTitle = type;
    if (type == "Other") {
      if (title == null || title == "") {
        Fluttertoast.showToast(msg: "Enter URL title first");
        return false;
      }
      urlTitle = title;
    }

    link_model.Link newLink = link_model.Link(title: urlTitle, url: url);

    /// add link to firestore
    DocumentReference<Map<String, dynamic>> documentRef
      = FirebaseFirestore.instance.collection('users').doc(UserData.uid);


    await documentRef.update({"links": FieldValue.arrayUnion([newLink.toJson()])});

    UserData.userModel.links ??= [];
    UserData.userModel.links!.add(newLink);
    emit(UserData.userModel.clone());
    return true;
  }


  void launchLink(link_model.Link link) async {
    NavigatorState navigator = Navigator.of(context);

    if (await canLaunchUrl(Uri.parse(link.url))) {
      navigator.push(
        MaterialPageRoute(
          builder: (context) => WebView(url: link.url, title: link.title)
        )
      );
    } else {
      Fluttertoast.showToast(msg: "Cannot launch this URL");
    }
  }

  void openPdf() async {
    if (state.cvLink == null) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MyHomePage(
          fileUrl: state.cvLink!,
          title: "${state.name} CV"
        )
      )
    );
  }

  Future<void> deleteLink(int linkIndex) async {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return ConfirmMessage(
            title: "DELETE LINK",
            content: "Are you sure you want to delete ${state.links![linkIndex].title} link",
            onConfirm: () async {
              DocumentReference<Map<String, dynamic>> documentRef
              = FirebaseFirestore.instance.collection('users').doc(UserData.uid);

              UserData.userModel.links?.removeAt(linkIndex);

              await documentRef.update({"links": link_model.Link.toJsonList(UserData.userModel.links)});
              emit(UserData.userModel.clone());
            },
          );
        }
      )
    );
  }

  void openChat() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatUsers(
          contact: Contact(
            user: state,
            lastMessageTime: 0
          )
        )
      )
    );
  }
}
