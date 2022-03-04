import 'package:flutter_miarmapp/models/user_with_post.dart';

abstract class UserPostRepository {
  Future<UserData> fetchUsers();
}
