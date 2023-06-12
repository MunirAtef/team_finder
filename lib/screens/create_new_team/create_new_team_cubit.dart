
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:team_finder/firebase/firestore.dart';
import 'package:team_finder/firebase/storage.dart';
import 'package:team_finder/models/team_card_model.dart';
import 'package:team_finder/screens/home_page/home_page_cubit.dart';
import 'package:team_finder/shared/pick_files.dart';
import 'package:team_finder/shared/user_data.dart';


class NewTeamState {
  List<String> skills = [];
  String? selectedCategory;
  File? image;
  bool isLoading;

  NewTeamState({
    this.skills = const [],
    this.selectedCategory,
    this.image,
    this.isLoading = false
  });

  NewTeamState updateSkills(List<String> newSkills) {
    return NewTeamState(
      skills: newSkills,
      selectedCategory: selectedCategory,
      image: image,
      isLoading: isLoading
    );
  }

  NewTeamState updateCategory(String? newCategory) {
    return NewTeamState(
        skills: skills,
        selectedCategory: newCategory,
        image: image,
        isLoading: isLoading
    );
  }

  NewTeamState updateImage(File? newImage) {
    return NewTeamState(
        skills: skills,
        selectedCategory: selectedCategory,
        image: newImage,
        isLoading: isLoading
    );
  }

  NewTeamState updateLoading(bool newValue) {
    return NewTeamState(
        skills: skills,
        selectedCategory: selectedCategory,
        image: image,
        isLoading: newValue
    );
  }
}


class NewTeamCubit extends Cubit<NewTeamState> {
  BuildContext context;
  NewTeamCubit(this.context) : super(NewTeamState());

  void setInitial(BuildContext context) => this.context = context;


  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController skillController = TextEditingController();


  Future<void> pickImage() async {
    File? pickedImage = await PickImage.pickImage(
      context,
      state.image == null? null: () {
        Navigator.of(context).pop();
        emit(state.updateImage(null));
      }
    );

    if (pickedImage != null) {
      emit(state.updateImage(pickedImage));
    }
  }

  void addSkill() {
    String skill = skillController.text.trim();
    skillController.clear();
    if (skill.isEmpty) {
      Fluttertoast.showToast(msg: "No Skill Entered");
      return;
    }

    emit(state.updateSkills(List.from(state.skills)..add(skill)));
  }

  void removeSkill(int index) {
    emit(state.updateSkills(List.from(state.skills)..removeAt(index)));
  }

  void updateCategory(String newValue) {
    state.selectedCategory = newValue;
    categoryController.text = newValue;
    if (newValue == "Other") categoryController.clear();
    emit(state.updateCategory(newValue));
  }

  Future<void> addTeam() async {
    HomePageCubit homePageCubit = BlocProvider.of<HomePageCubit>(context);

    String name = nameController.text.trim();
    String description = descriptionController.text.trim();
    String? category = state.selectedCategory;
    File? image = state.image;
    String? imageUrl;

    if (name == "") return showToast("Team name is required");
    if (description == "") return showToast("Team description is required");
    if (category == "Other") category = categoryController.text.trim();
    if (category == null || category == "") return showToast("Team category is required");

    emit(state.updateLoading(true));

    String teamId = Firestore.getTeamKey();

    if (image != null) {
      imageUrl = await Storage.uploadFile(
        path: StoragePath.team(teamId, "teamIcon"),
        file: image
      );
    }

    Map<String, dynamic> teamData = TeamCardModel(
      id: teamId,
      adminID: UserData.uid,
      teamName: name,
      teamCategory: category,
      teamDescription: description,
      requiredSkills: state.skills,
      imageUrl: imageUrl,
      creationDate: Timestamp.now().millisecondsSinceEpoch
    ).toJson();

    await Firestore.uploadTeamData(teamId, teamData);
    await Firestore.appendToJoinedTeams(userId: UserData.uid, teamId: teamId);

    UserData.userModel.joinedTeams.add(teamId);

    clearAll();
    showToast("Team created successfully");
    homePageCubit.update();
  }

  void showToast(String msg) {
    Fluttertoast.showToast(msg: msg);
    emit(state.updateLoading(false));
  }

  void clearAll() {
    nameController.clear();
    descriptionController.clear();
    categoryController.clear();
    skillController.clear();
  }
}

