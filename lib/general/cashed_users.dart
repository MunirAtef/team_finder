
import 'package:team_finder/firebase/firestore.dart';
import 'package:team_finder/models/user_model.dart';

class CashedUsers {
  static Map<String, UserModel> users = {};

  static Future<UserModel?> getUser(String id) async {
    if (users.containsKey(id)) return users[id]!;
    UserModel? user = await Firestore.getUserById(userId: id);
    if (user == null) return null;
    users[id] = user;
    return user;
  }
}



