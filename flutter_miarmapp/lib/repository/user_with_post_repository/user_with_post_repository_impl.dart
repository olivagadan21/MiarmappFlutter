import 'dart:convert';

import 'package:flutter_miarmapp/models/user_with_post.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'user_with_post_repository.dart';

class UserPostRepositoryImpl extends UserPostRepository {
  final Client _client = Client();

  @override
  Future<UserData> fetchUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await _client.get(Uri.parse('${Constant.baseUrl}/me'),
        headers: {'Authorization': 'Bearer ${prefs.getString('token')}'});
    if (response.statusCode == 200) {
      return UserData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Fail to load users');
    }
  }
}
