
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_finder/screens/create_new_team/create_new_team_cubit.dart';
import 'package:team_finder/shared/user_data.dart';
import 'package:team_finder/shared_widgets/circle_image.dart';
import 'package:team_finder/shared_widgets/edited_button.dart';
import 'package:team_finder/shared_widgets/edited_container.dart';
import 'package:team_finder/shared_widgets/edited_text_field.dart';


class NewTeam extends StatelessWidget {
  const NewTeam({super.key});

  Stack teamImage(double screenWidth, NewTeamCubit cubit) {
    File? image = cubit.state.image;

    return Stack(
      children: [
        CircleImage(
          radius: screenWidth / 4 + 5,
          file: image,
          placeHolder: EditedContainer(
            borderRadius: BorderRadius.all(Radius.circular(screenWidth / 4 + 5)),
            backgroundColor: Colors.grey[200]!,
            shadowColor: Colors.grey[700]!,
          ),
        ),

        Positioned(
          right: 8,
          bottom: 8,
          child: CircleAvatar(
            radius: 23,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.black,
              child: IconButton(
                  onPressed: () async => await cubit.pickImage(),
                  icon: const Icon(Icons.add_a_photo, color: Colors.white)
              ),
            ),
          ),
        )
      ],
    );
  }

  Column showSkills(NewTeamCubit cubit) {
    return Column(
      children: [
        for (int i = 0; i < cubit.state.skills.length; i++)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            decoration: BoxDecoration(
              color: i % 2 == 0? Colors.grey[200] : Colors.white,
              border: const Border(
                bottom: BorderSide(color: Colors.grey, width: 2),
              ),
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                    child: Text(
                      cubit.state.skills[i],
                      maxLines: 3,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),

                IconButton(
                  onPressed: () => cubit.removeSkill(i),
                  icon: const Icon(Icons.delete, color: Colors.red)
                )
              ],
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    NewTeamCubit cubit = BlocProvider.of<NewTeamCubit>(context);
    cubit.setInitial(context);

    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[100],
        toolbarHeight: 60,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        title: const Text(
          "CREATE NEW TEAM",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600
          )
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.symmetric(vertical: 15),

          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.black),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[900]!
              ),
              const BoxShadow(
                color: Colors.white,
                blurRadius: 8,
                spreadRadius: -4
              )
            ]
          ),

          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: BlocBuilder<NewTeamCubit, NewTeamState>(
              builder: (BuildContext context, NewTeamState state) {
                return Column(
                  children: [
                    const SizedBox(height: 30),
                    teamImage(width, cubit),

                    EditedTextField(
                      controller: cubit.nameController,
                      hint: "Team Name",
                      margin: const EdgeInsets.fromLTRB(30, 30, 30, 10),
                      prefixText: "Name",
                    ),

                    Divider(thickness: 2, color: Colors.cyan[800]),

                    EditedTextField(
                      controller: cubit.descriptionController,
                      hint: "Team Description",
                      maxLines: 3,
                      maxHeight: 100,
                      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      prefix: Icon(Icons.description, size: 30, color: Colors.cyan[700]),
                    ),

                    Divider(thickness: 2, color: Colors.cyan[800]),

                    Container(
                      height: 55,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10)
                        ),
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[800]!
                          ),
                          BoxShadow(
                              color: Colors.grey[800]!,
                              blurRadius: 12,
                              spreadRadius: -2
                          ),
                        ],
                      ),

                      child: DropdownButton<String>(
                        value: state.selectedCategory,
                        dropdownColor: Colors.grey[800],
                        hint: Text(
                          "Choose Team Category",
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
                        onChanged: (String? newValue) => cubit.updateCategory(newValue!),
                        items: categories.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),

                    EditedTextField(
                      controller: cubit.categoryController,
                      hint: "Team Category",
                      prefix: Icon(Icons.category, size: 30, color: Colors.cyan[700]),
                      margin: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                      isReadOnly: cubit.state.selectedCategory != "Other",
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10)
                      ),
                    ),

                    Divider(thickness: 2, color: Colors.cyan[800]),

                    EditedTextField(
                      controller: cubit.skillController,
                      hint: "Add New Skill",
                      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      prefixText: "Skill",
                      maxLines: 3,
                      maxHeight: 100,
                      suffix: IconButton(
                        onPressed: () => cubit.addSkill(),
                        icon: Icon(Icons.add_box_rounded, color: Colors.cyan[700]),
                      ),
                    ),

                    showSkills(cubit),

                    const SizedBox(height: 10),
                    Divider(thickness: 2, color: Colors.cyan[800]),


                    EditedButton(
                      color: Colors.cyan[600]!,
                      text: "ADD TEAM",
                      leading: Image.asset("assets/images/add_team_icon.png"),
                      isLoading: state.isLoading,
                      onPressed: () => cubit.addTeam()
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

