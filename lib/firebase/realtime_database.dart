
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:team_finder/shared/user_data.dart';

class RealtimePaths {
  static String teamLastMessage(String teamId) =>
    "teams/$teamId/lastMessage";

  static String userLastOpened(String userId, String teamId) =>
    "teams/$teamId/lastSeenMessage/$userId";

  static String user(String userId) =>
    "users/$userId";

  static String incomingRequests(String userId) =>
    "users/$userId/requests";

  static String incomingChat(String userId) =>
    "users/$userId/chat";

  static String incomingAcceptance(String userId) =>
      "users/$userId/acceptance";

  static String adminTeamRequests(String adminId, String teamId) =>
    "users/$adminId/requests/$teamId";

  static String userRequestToAdmin(String adminId, String teamId, String userId) =>
    "users/$adminId/requests/$teamId/$userId";

  static String userAcceptance(String userId, String teamId) =>
    "users/$userId/acceptance/$teamId";

  static String userChat(String receiverId, String senderId) =>
    "users/$receiverId/chat/$senderId";
}



class RealtimeDatabase {
  static final FirebaseDatabase instance = FirebaseDatabase.instance;

  static Future<void> deleteRequest({required String adminId, required String teamId, required userId}) async {
    await instance.ref(RealtimePaths.userRequestToAdmin(adminId, teamId, userId)).remove();
  }

  static Future<List<String>> getTeamRequests({required String adminId, required String teamId}) async {
    DatabaseEvent event = await instance.ref(RealtimePaths.adminTeamRequests(adminId, teamId)).once();
    List<String> users = event.snapshot.children.map((e) => "${e.key}").toList();
    return users;
  }

  static Future<void> setRequest({required String adminId, required String teamId, required String userId}) async {
    await instance.ref(RealtimePaths.userRequestToAdmin(adminId, teamId, userId)).set(1);
  }

  static Future<void> setAcceptance({required String teamId, required String userId}) async {
    await instance.ref(RealtimePaths.userAcceptance(userId, teamId)).set(1);
  }

  static Future<void> setLastOpened({required String userId, required String teamId, required int value}) async {
    await instance.ref(RealtimePaths.userLastOpened(userId, teamId)).set(value);
  }

  static Future<void> setLastSentMessage({required String teamId, required int value}) async {
    await instance.ref(RealtimePaths.teamLastMessage(teamId)).set(value);
  }

  static Future<int> getLastOpened({required String userId, required String teamId}) async {
    DatabaseEvent event = await instance.ref(RealtimePaths.userLastOpened(userId, teamId)).once();
    return (event.snapshot.value ?? 0) as int;
  }

  static StreamSubscription<DatabaseEvent> setListener({
    required String path,
    required Future<void> Function(DatabaseEvent event) onEvent
  }) {
    StreamSubscription<DatabaseEvent> listener = instance.ref(path).onValue
      .listen((DatabaseEvent event) async { await onEvent(event); });

    return listener;
  }

  static Future<void> notifyUserWithMessage({required String userId, required int value}) async {
    await instance.ref(RealtimePaths.userChat(userId, UserData.uid)).set(value);
  }

  static Future<void> deleteChatNotification({required String userId}) async {
    await instance.ref(RealtimePaths.userChat(UserData.uid, userId)).remove();
  }
}

