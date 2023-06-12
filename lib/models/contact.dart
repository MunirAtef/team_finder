
import 'package:team_finder/models/user_model.dart';

class Contact {
  UserModel user;
  int lastMessageTime;
  bool isActive;

  Contact({
    required this.user,
    required this.lastMessageTime,
    this.isActive = false
  });
}


