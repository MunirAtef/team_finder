
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:team_finder/screens/register/upload_data_cubit.dart';
import 'package:team_finder/shared_widgets/circle_image_with_button.dart';
import 'package:team_finder/shared_widgets/edited_button.dart';
import 'package:team_finder/shared_widgets/edited_container.dart';
import 'package:team_finder/shared_widgets/edited_text_field.dart';
import 'package:team_finder/shared_widgets/login_background.dart';


class UploadData extends StatelessWidget {
  const UploadData({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final UploadDataCubit cubit = BlocProvider.of<UploadDataCubit>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        toolbarHeight: 60,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        title: const Text(
          "COMPLETE YOUR REGISTRATION",
          style: TextStyle(
            fontWeight: FontWeight.w600
          ),
        ),
      ),

      body: Stack(
        children: [
          const LoginBackground(),

          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: BlocBuilder<UploadDataCubit, UploadDataState>(
              builder: (BuildContext context, UploadDataState state) {
                return Column(
                  children: [
                    const SizedBox(height: 60),

                    CircleImageWithButton(
                      radius: width / 4,
                      file: state.profilePicture,
                      placeHolder: Image.asset("assets/images/user_icon.png"),
                      onPress: () async => await cubit.uploadProfilePicture(context),
                    ),

                    EditedTextField(
                      controller: cubit.nameController,
                      hint: "Name",
                      prefixText: "Name",
                      margin: const EdgeInsets.fromLTRB(30, 30, 30, 10),
                    ),

                    EditedTextField(
                      controller: cubit.bioController,
                      hint: "Bio",
                      prefixText: "Bio",
                      maxLines: 3,
                      maxHeight: 100,
                      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    ),

                    EditedTextField(
                      controller: cubit.aboutController,
                      hint: "About",
                      prefix: Icon(Icons.info_outline, color: Colors.cyan[700]),
                      maxLines: 3,
                      maxHeight: 100,
                      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    ),

                    cvContainer(cubit),

                    EditedButton(
                      text: "UPLOAD CV",
                      margin: const EdgeInsets.only(top: 0),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30)
                      ),
                      leading: const Icon(
                        Icons.upload_rounded,
                        color: Colors.white
                      ),
                      color: Colors.cyan[700]!,
                      onPressed: () async => cubit.uploadCv(),
                    ),

                    EditedButton(
                      color: Colors.red,
                      text: "DONE",
                      leading: const Icon(Icons.check_circle, color: Colors.white),
                      isLoading: state.isLoading,
                      margin: const EdgeInsets.only(top: 30, bottom: 30),
                      onPressed: () async => await cubit.uploadData(context),
                    ),
                  ],
                );
              },

            ),
          )
        ],
      )
    );
  }


  EditedContainer cvContainer(UploadDataCubit cubit) {
    Widget text;
    if (cubit.state.uploadedCv == null) {
      text = const Text(
        "No File Uploaded",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.red
        )
      );
    } else {
      text = Row(
        children: [
          const SizedBox(width: 20),
          const Icon(FontAwesomeIcons.solidFilePdf, color: Colors.red),
          const SizedBox(width: 10),

          Expanded(
            child: Text(
              cubit.state.uploadedCv!.path.split("/").last,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black
              )
            ),
          ),

          IconButton(
            onPressed: () => cubit.deleteCv(),
            icon: const Icon(Icons.delete),
            color: Colors.red
          ),

          const SizedBox(width: 20),
        ],
      );
    }

    return EditedContainer(
      height: 60,
      shadowColor: Colors.grey,
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(42, 20, 42, 0),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10)
      ),

      child: Center(child: text)
    );
  }
}

