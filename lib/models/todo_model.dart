
class TodoModel {
  late String id;
  late String content;
  late String userId;
  late int timestamp;
  late int todoCase;

  TodoModel({
    required this.id,
    required this.content,
    required this.userId,
    this.timestamp = 0,
    this.todoCase = 0
  });


  TodoModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    content = json["content"];
    userId = json["userId"];
    timestamp = json["timestamp"];
    todoCase = json["todoCase"];
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "content": content,
    "userId": userId,
    "timestamp": timestamp,
    "todoCase": todoCase,
  };

  static List<TodoModel>? fromJsonList(dynamic todos) {
    return (todos as List?)?.map((todo) => TodoModel.fromJson(todo)).toList();
  }

  static List<Map<String, dynamic>>? toJsonList(List<TodoModel>? todos) {
    return todos?.map((TodoModel todo) => todo.toJson()).toList();
  }
}

