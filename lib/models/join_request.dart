

class JoinRequest {
  late String userId;
  late String adminId;
  late String teamId;

  JoinRequest({
    required this.userId,
    required this.adminId,
    required this.teamId
  });

  JoinRequest.fromJson(Map<String, dynamic> json) {
    userId = json["userId"];
    adminId = json["adminId"];
    teamId = json["teamId"];
  }

  Map<String, String> toJson() {
    return {
      "userId": userId,
      "adminId": adminId,
      "teamId": teamId
    };
  }


  static List<JoinRequest> fromJsonList(dynamic requests) {
    return (requests as List?)?.map(
      (request) => JoinRequest.fromJson(request)
    ).toList() ?? [];
  }

  static List<Map<String, String>> toJsonList(List<JoinRequest>? requests) {
    return requests?.map((request) => request.toJson()).toList() ?? [];
  }
}


