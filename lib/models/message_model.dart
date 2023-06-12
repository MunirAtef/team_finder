

class MessageModel {
  late String content;
  late String senderId;
  late String sourceId;
  late int timestamp;

  MessageModel({
    required this.content,
    required this.senderId,
    required this.sourceId,
    required this.timestamp
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    content = json["content"];
    senderId = json["senderId"];
    sourceId = json["sourceId"];
    timestamp = json["timestamp"];
  }

  Map<String, dynamic> toJson() {
    return {
      "content": content,
      "senderId": senderId,
      "sourceId": sourceId,
      "timestamp": timestamp
    };
  }
}

