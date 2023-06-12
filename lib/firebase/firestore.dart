
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team_finder/models/join_request.dart';
import 'package:team_finder/models/todo_model.dart';
import 'package:team_finder/models/user_model.dart';


class Firestore {
  static final FirebaseFirestore instance = FirebaseFirestore.instance;

  static String getTeamKey() => instance.collection('teams').doc().id;

  static Future<void> uploadTeamData(String key, Map<String, dynamic> data) async {
    DocumentReference<Map<String, dynamic>> newDocRef
      = instance.collection('teams').doc(key);
    await newDocRef.set(data);
  }

  static Future<void> appendUserToTeam({required String teamId, required String userId}) async {
    await instance.collection('teams').doc(teamId)
      .update({"membersID": FieldValue.arrayUnion([userId])});
  }

  static Future<void> appendToJoinedTeams({required String userId, required String teamId}) async {
    await instance.collection('users').doc(userId)
      .update({"joinedTeams": FieldValue.arrayUnion([teamId])});
  }

  static Future<void> appendToJoinRequests({required JoinRequest request}) async {
    await instance.collection('users').doc(request.userId)
      .update({"joinRequests": FieldValue.arrayUnion([request.toJson()])});
  }

  static Future<void> updateJoinRequests({required String userId, required List<JoinRequest> requests}) async {
    await FirebaseFirestore.instance.collection('users').doc(userId)
      .update({"joinRequests": JoinRequest.toJsonList(requests)});
  }

  static Future<Map<String, dynamic>?> getDocument(String collection, String document) async {
    DocumentReference<Map<String, dynamic>> documentRef =
      instance.collection(collection).doc(document);

    return (await documentRef.get()).data();
  }

  static Future<UserModel?> getUserById({required String userId}) async {
    Map<String, dynamic>? document = await getDocument("users", userId);
    if (document == null) return null;
    return UserModel.fromJson(document);
  }

  static Future<void> setDocument({required String collection, required String document, required data}) async {
    await instance.collection(collection).doc(document).set(data);
  }

  static Future<String> postTodo({required String teamId, required TodoModel todo}) async {
    CollectionReference<Map<String, dynamic>> todoCollection =
      instance.collection("teams_data").doc(teamId).collection("todos");
    String id = todoCollection.doc().id;
    todo.id = id;

    await todoCollection.doc(id).set(todo.toJson());
    return id;
  }

  static Future<void> updateTodoContent({required String teamId, required String todoId, required String newContent}) async {
    await instance.collection("teams_data").doc(teamId).collection("todos")
      .doc(todoId).update({"content": newContent});
  }

  static Future<void> updateTodoCase({required String teamId, required String todoId, required int newCase}) async {
    await instance.collection("teams_data").doc(teamId).collection("todos")
      .doc(todoId).update({"todoCase": newCase});
  }

  static Future<void> deleteTodo({required String teamId, required String todoId}) async {
    await instance.collection("teams_data").doc(teamId).collection("todos")
      .doc(todoId).delete();
  }

  static Future<List<TodoModel>> getAllTodos({required String teamId}) async {
    QuerySnapshot<Map<String, dynamic>> query =
      await instance.collection("teams_data").doc(teamId).collection("todos").orderBy("timestamp").get();

    return query.docs.map((e) => TodoModel.fromJson(e.data())).toList();
  }
}

