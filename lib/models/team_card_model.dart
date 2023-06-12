
class TeamCardModel {
  late String id;
  late String adminID;
  late String teamName;
  late String teamCategory;
  late String teamDescription;
  late int creationDate;
  String? imageUrl;
  List<String>? requiredSkills;
  List<String> membersID = [];

  int lastMessageTime = 0;
  int lastSeenMessage = 0;

  TeamCardModel({
    required this.id,
    required this.adminID,
    required this.teamName,
    required this.teamCategory,
    required this.teamDescription,
    required this.creationDate,
    this.imageUrl,
    this.requiredSkills,
    this.membersID = const [],
  });

  TeamCardModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    adminID = json["adminID"];
    teamName = json["teamName"];
    teamCategory = json["teamCategory"];
    teamDescription = json["teamDescription"];
    imageUrl = json["imageUrl"];
    creationDate = json["creationDate"];

    List? skills = json["requiredSkills"] as List?;
    requiredSkills = skills?.map((e) => "$e").toList() ?? [];


    List? membersID = json["membersID"] as List?;
    this.membersID = membersID?.map((e) => "$e").toList() ?? [];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "adminID": adminID,
      "teamName": teamName,
      "teamCategory": teamCategory,
      "teamDescription": teamDescription,
      "creationDate": creationDate,
      if (requiredSkills != null) "requiredSkills": requiredSkills,
      if (imageUrl != null) "imageUrl": imageUrl,
      "membersID": membersID,
    };
  }
}


TeamCardModel tempModel = TeamCardModel(
  id: "TEAM_ID",
  adminID: "Tye0HiNdCYhlXCtzQ9xlS2C3vB12",
  teamName: "Team Name",
  teamCategory: "Mobile App Development",
  teamDescription: "This is description on the team, that contains some "
    "information like team project and required skills"
    "information like team project and required skills",
  requiredSkills: ["Mobile Development", "UI/UX design", "Backend"],
  imageUrl: null,
  creationDate: 0
);

String url = "https://img.freepik.com/premium-vector/teamwork-collaboration-banner-with-colored-line-icons-team-goal-inspiration-career-typography-infographics-concept-team-work-isolated-vector-illustration_108855-3137.jpg";



Map teamModel = {
  "id": "team_id",
  "adminID": "8888",
  "teamName": "Team Name",
  "teamCategory": "Mobile App Development",
  "teamDescription": "This is description on the team, that contains some information",
  "requiredSkills": ["Mobile Development", "UI/UX design", "Backend"],
  "imageUrl": "https://image",
  "creationDate": 0,
  "membersID": ["member1", "member2", "member3"]
};


