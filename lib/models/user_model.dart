

import 'package:team_finder/models/join_request.dart';
import 'package:team_finder/models/link_model.dart';

class UserModel {
  late String id;
  late String name;
  String? bio;
  String? imageUrl;
  String? about;
  List<Link>? links;
  String? cvLink;
  List<String> joinedTeams = [];
  List<JoinRequest> joinRequests = [];

  UserModel({
    required this.id,
    required this.name,
    this.bio,
    this.imageUrl,
    this.about,
    this.cvLink,
    this.links,
    this.joinedTeams = const [],
    this.joinRequests = const [],
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    bio = json["bio"];
    imageUrl = json["imageUrl"];
    about = json["about"];
    links = Link.fromJsonList(json["links"]);
    cvLink = json["cvLink"];
    joinRequests = JoinRequest.fromJsonList(json["joinRequests"]);

    List? teams = json["joinedTeams"] as List?;
    joinedTeams = teams?.map((e) => "$e").toList() ?? [];
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "bio": bio,
    "about": about,
    "imageUrl": imageUrl,
    "cvLink": cvLink,
    "joinedTeams": joinedTeams,
    "joinRequests": joinRequests,
    "links": Link.toJsonList(links)
  };

  UserModel clone() {
    return UserModel(
      id: id,
      name: name,
      bio: bio,
      about: about,
      imageUrl: imageUrl,
      cvLink: cvLink,
      joinedTeams: joinedTeams,
      joinRequests: joinRequests,
      links: links
    );
  }
}



UserModel tempPerson = UserModel(
  id: "NH5A3dj4u7f1LXCMXi4dctjdPBs2",
  name: "Munir M. Atef",
  bio: "Mobile Developer (Jetpack compose, Flutter)",
  about: "Student in third year at FCAI USC",
  imageUrl: "https://img.freepik.com/premium-vector/teamwork-collaboration-banner-with-colored-line-icons-team-goal-inspiration-career-typography-infographics-concept-team-work-isolated-vector-illustration_108855-3137.jpg",
  cvLink: "users/id/my_cv.pdf",
  joinRequests: [],
  links: [
    Link(title: "WhatsApp", url: "+201146721499"),
    Link(title: "Facebook", url: "+201146721499"),
    Link(title: "Twitter", url: "+201146721499"),
    Link(title: "Instagram", url: "+201146721499"),
    Link(title: "Linkedin", url: "+201146721499"),
    Link(title: "Github", url: "+201146721499"),
  ]
);

Map<String, Object> person = {
  "id": "NH5A3dj4u7f1LXCMXi4dctjdPBs2",
  "name": "Munir M. Atef",
  "bio": "Mobile Developer (Jetpack compose, Flutter)",
  "about": "Student in third year at FCAI USC",
  "imageUrl": "https://img.freepik.com/premium-vector/teamwork-collaboration-banner-with-colored-line-icons-team-goal-inspiration-career-typography-infographics-concept-team-work-isolated-vector-illustration_108855-3137.jpg",
  "cvLink": "users/id/my_cv.pdf",
  "links": [
    {"title": "WhatsApp", "url": "+201146721499"},
    {"title": "Facebook", "url": "+201146721499"},
    {"title": "Twitter", "url": "+201146721499"},
    {"title": "Instagram", "url": "+201146721499"},
    {"title": "Linkedin", "url": "+201146721499"},
    {"title": "Github", "url": "+201146721499"},
  ]
};



