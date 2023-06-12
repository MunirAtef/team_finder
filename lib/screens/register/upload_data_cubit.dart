
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:team_finder/firebase/firestore.dart';
import 'package:team_finder/firebase/storage.dart';
import 'package:team_finder/models/user_model.dart';
import 'package:team_finder/screens/routes_holder/routes_holder_ui.dart';
import 'package:team_finder/shared/pick_files.dart';
import 'package:team_finder/shared/user_data.dart';

class UploadDataState {
  bool isLoading;
  File? uploadedCv;
  File? profilePicture;

  UploadDataState({
    this.isLoading = false,
    this.uploadedCv,
    this.profilePicture
  });


  UploadDataState setLoadingTo(bool loading) {
    return UploadDataState(
        isLoading: loading,
        uploadedCv: uploadedCv,
        profilePicture: profilePicture
    );
  }

  UploadDataState setProfilePicture(File? newImage) {
    return UploadDataState(
      isLoading: isLoading,
      uploadedCv: uploadedCv,
      profilePicture: newImage
    );
  }

  UploadDataState setPdf(File? newPdf) {
    return UploadDataState(
      isLoading: isLoading,
      uploadedCv: newPdf,
      profilePicture: profilePicture
    );
  }
}


class UploadDataCubit extends Cubit<UploadDataState> {
  UploadDataCubit(): super(UploadDataState());

  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController aboutController = TextEditingController();

  Future<void> uploadData(BuildContext context) async {
    NavigatorState navigator = Navigator.of(context);

    String name = nameController.text.trim();
    String bio = bioController.text.trim();
    String about = aboutController.text.trim();

    if (name.length < 4) {
      Fluttertoast.showToast(msg: "Too short name");
      return;
    }

    emit(state.setLoadingTo(true));

    /// upload image to firebase storage
    String? imageUrl = await Storage.uploadFile(
      path: 'users/${UserData.uid}/profileImage',
      file: state.profilePicture,
    );

    /// upload image to firebase storage
    String? cvLink = await Storage.uploadFile(
      path: 'users/${UserData.uid}/cvFile',
      file: state.uploadedCv
    );

    UserModel model = UserModel(
      id: UserData.uid,
      name: name,
      imageUrl: imageUrl,
      bio: bio == ""? null: bio,
      about: about == ""? null: about,
      cvLink: cvLink
    );

    await Firestore.setDocument(collection: "users", document: UserData.uid, data: model.toJson());
    emit(state.setLoadingTo(false));
    navigator.pushReplacement(
      MaterialPageRoute(builder: (context) => const RoutesHolder())
    );
  }

  Future<void> uploadCv() async {
    File? pdf = await PickFile.pickPdf();
    if (pdf != null) emit(state.setPdf(pdf));
  }

  void deleteCv() {
    emit(state.setPdf(null));
  }

  Future<void> uploadProfilePicture(BuildContext context) async {
    File? image = await PickImage.pickImage(
      context,
      state.profilePicture == null? null: () {
        deleteProfilePicture(context);
      }
    );

    if (image != null) emit(state.setProfilePicture(image));
  }

  void deleteProfilePicture(BuildContext context) {
    Navigator.of(context).pop();
    emit(state.setProfilePicture(null));
  }

}
