
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_finder/models/link_model.dart';
import 'package:team_finder/models/user_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:team_finder/screens/profile/profile_cubit.dart';
import 'package:team_finder/shared/user_data.dart';
import 'package:team_finder/shared_widgets/circle_image.dart';
import 'package:team_finder/shared_widgets/edited_button.dart';
import 'package:team_finder/shared_widgets/edited_container.dart';
import 'package:team_finder/shared_widgets/info_box.dart';



class PersonalProfile extends StatelessWidget {
  final UserModel userModel;

  PersonalProfile({Key? key, required this.userModel}) : super(key: key) {
    isMe = userModel.id == UserData.uid;
    darkColor = isMe? Colors.cyan[600]!: Colors.green;
    darkerColor = isMe? Colors.cyan[800]!: Colors.green[800]!;
    lightColor = isMe? Colors.cyan[100]!: Colors.green[100]!;
  }

  late final bool isMe;
  late final Color darkColor;
  late final Color darkerColor;
  late final Color lightColor;


  @override
  Widget build(BuildContext context) {
    ProfileCubit cubit = BlocProvider.of<ProfileCubit>(context)
      ..setInitial(userModel, context);

    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
        backgroundColor: darkColor,
      ),

      body: BlocBuilder<ProfileCubit, UserModel>(
        builder: (BuildContext context, state) {
          return ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  EditedContainer(
                    height: width * 3 / 4 + 80,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    backgroundColor: Colors.grey[100]!,
                    shadowColor: Colors.grey[600]!,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                  ),

                  Container(
                    width: double.infinity,
                    height: width / 2,
                    margin: EdgeInsets.only(bottom: width / 4 + 80, left: 10, right: 10),
                    decoration: BoxDecoration(
                      color: lightColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(width / 3),
                        bottomRight: Radius.circular(width / 3),
                        topRight: const Radius.circular(10),
                        topLeft: const Radius.circular(10)
                      )
                    ),
                  ),

                  Positioned(
                    bottom: 90,
                    child: CircleImage(
                      radius: width / 4,
                      network: userModel.imageUrl,
                      placeHolder: Image.asset("assets/images/user_icon.png")
                    )
                  ),

                  Positioned(
                    bottom: 30,
                    child: SizedBox(
                      height: 50,
                      width: width,
                      child: editOrChatButton(context, cubit),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 20),

              EditedContainer(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 5),
                backgroundColor: Colors.grey[100]!,
                shadowColor: Colors.grey[600]!,
                borderRadius: const BorderRadius.all(Radius.circular(20)),

                child: Column(
                  children: [
                    Text(
                      userModel.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 25
                      ),
                    ),

                    if (userModel.bio != null)
                      Text(
                        userModel.bio!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.grey[700]
                        ),
                      ),

                    aboutSection(),

                    showLinks(cubit),

                    cvSection(cubit),

                    const SizedBox(height: 10)
                  ],
                ),
              ),

              const SizedBox(height: 20)
            ],
          );
        },
      ),
    );
  }


  Widget editOrChatButton(BuildContext context, ProfileCubit profileCubit) {
    if (isMe) {
      return EditedButton(
        leading: const Icon(Icons.edit, color: Colors.white),
        color: darkColor,
        text: "EDIT PROFILE",
        margin: EdgeInsets.zero,
        onPressed: () => showBottomSheet(context, profileCubit)
      );
    } else {
      return EditedButton(
        leading: const Icon(Icons.chat, color: Colors.white),
        color: darkColor,
        text: "CHAT",
        margin: EdgeInsets.zero,
        onPressed: () => profileCubit.openChat(),
      );
    }
  }

  Widget showLinks(ProfileCubit cubit) {
    List<Link>? links = userModel.links;
    if (links == null || links.isEmpty) return const SizedBox();
    return InfoBox(
        title: "LINKS",
        margin: const EdgeInsets.symmetric(vertical: 10),
        childPadding: const EdgeInsets.symmetric(vertical: 10),
        headerColor: darkerColor,

        child: Column(
          children: [
            for (int i = 0; i < links.length; i++)
              ListTile(
                leading: getLinkIcon(links[i].title),
                trailing: !isMe? null: IconButton(
                  onPressed: () async => await cubit.deleteLink(i),
                  icon: const Icon(Icons.delete, color: Colors.red)
                ),

                title: Text(
                  links[i].title,
                  style: const TextStyle(fontWeight: FontWeight.w600)
                ),
                subtitle: Text(links[i].url, maxLines: 2, overflow: TextOverflow.ellipsis),
                minLeadingWidth : 10,
                onTap: () => cubit.launchLink(links[i]),
              )
          ],
        )
    );
  }

  Widget aboutSection() {
    if (userModel.about == null) return const SizedBox();

    return InfoBox(
      title: "ABOUT",
      margin: const EdgeInsets.symmetric(vertical: 10),
      childPadding: const EdgeInsets.symmetric(vertical: 20),
      headerColor: darkerColor,

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          userModel.about!,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600
          ),
        ),
      ),
    );
  }

  Widget cvSection(ProfileCubit cubit) {
    if (userModel.cvLink == null) return const SizedBox();
    return InfoBox(
      title: "CV",
      margin: const EdgeInsets.symmetric(vertical: 10),
      childPadding: const EdgeInsets.symmetric(vertical: 20),
      headerColor: darkerColor,

      child: InkWell(
        onTap: () => cubit.openPdf(),
        child: EditedContainer(
          height: 70,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          shadowColor: Colors.grey,
          child: Row(
            children: [
              const SizedBox(width: 20),

              Icon(
                FontAwesomeIcons.solidFilePdf,
                color: Colors.red[600],
                size: 40,
              ),

              const SizedBox(width: 10),

              const Text(
                "CV.pdf",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20
                ),
              )
            ]
          )
        )
      )
    );
  }


  Icon getLinkIcon(String title) {
    return linksIcons[title] ?? const Icon(FontAwesomeIcons.link);
  }

  ListTile listTile({Widget? leading, required String title, required List<IconButton> actions}) {
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black
              ),
            ),
          ),

          ...actions,
        ],
      ),

      leading: leading ?? CircleAvatar(radius: 10, backgroundColor: darkColor),
    );
  }

  void showBottomSheet(BuildContext context, ProfileCubit profileCubit) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Edit Profile",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                ),

                const SizedBox(height: 16),

                listTile(
                  title: "Name",
                  actions: [
                    IconButton(
                      onPressed: () async => await profileCubit.updateName(),
                      icon: Icon(Icons.edit, color: darkColor)
                    ),
                  ]
                ),

                listTile(
                  title: "Bio",
                  actions: [
                    if (userModel.bio != null) IconButton(
                      onPressed: ()  async => await profileCubit.deleteBio(),
                      icon: const Icon(Icons.delete,color: Colors.red)
                    ),
                    IconButton(
                      onPressed: () async => await profileCubit.updateBio(),
                      icon: Icon(Icons.edit, color: darkColor)
                    ),
                  ]
                ),

                listTile(
                  title: "About",
                  actions: [
                    if (userModel.about != null) IconButton(
                      onPressed: ()  async => await profileCubit.deleteAbout(),
                      icon: const Icon(Icons.delete,color: Colors.red)
                    ),
                    IconButton(
                      onPressed: () async => await profileCubit.updateAbout(),
                      icon: Icon(Icons.edit, color: darkColor)
                    ),
                  ]
                ),

                listTile(
                  leading: Icon(Icons.image, color: darkColor),
                  title: "Profile Picture",
                  actions: [
                    if (userModel.imageUrl != null) IconButton(
                      onPressed: () async => await profileCubit.deleteProfilePicture(),
                      icon: const Icon(Icons.delete,color: Colors.red)
                    ),
                    IconButton(
                      onPressed: () async => await profileCubit.uploadProfilePicture(),
                      icon: Icon(Icons.add_a_photo, color: darkColor)
                    ),
                  ]
                ),

                listTile(
                  leading: Icon(FontAwesomeIcons.solidFilePdf, color: darkColor),
                  title: "CV",
                  actions: [
                    if (userModel.cvLink != null) IconButton(
                      onPressed: () async => await profileCubit.deleteCV(),
                      icon: const Icon(Icons.delete,color: Colors.red)
                    ),
                    IconButton(
                      onPressed: () async => await profileCubit.uploadCV(),
                      icon: Icon(Icons.upload_file, color: darkColor)
                    ),
                  ]
                ),


                listTile(
                  leading: Icon(FontAwesomeIcons.link, color: darkColor),
                  title: "Add url",
                  actions: [
                    IconButton(
                      onPressed: () => profileCubit.chooseLinkType(),
                      icon: Icon(Icons.add_link, color: darkColor)
                    ),
                  ]
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}


Map<String, Icon> linksIcons = {
  "Linkedin": const Icon(FontAwesomeIcons.linkedin, color: Colors.blue),
  "WhatsApp": const Icon(FontAwesomeIcons.whatsapp, color: Colors.green),
  "GitHub": const Icon(FontAwesomeIcons.github, color: Colors.black),
  "Twitter": const Icon(FontAwesomeIcons.twitter, color: Colors.blue),
  "Facebook": const Icon(FontAwesomeIcons.facebook, color: Colors.blue),
  "Instagram": const Icon(FontAwesomeIcons.instagram, color: Colors.purple),
};


