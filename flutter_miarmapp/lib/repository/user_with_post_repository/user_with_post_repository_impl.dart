import 'dart:convert';

import 'package:flutter_miarmapp/models/user_with_post.dart';
import 'package:http/http.dart';

import 'user_with_post_repository.dart';



class UserPostRepositoryImpl extends UserPostRepository {
  final Client _client = Client();

/*List<PublicacionData> myModels;
var response = await http.get("myUrl");

myModels=(json.decode(response.body) as List).map((i) =>
              MyModel.fromJson(i)).toList();*/

  @override
  Future<UserData> fetchUsers(String type) async {
    final response = await _client.get(Uri.parse('http://10.0.2.2:8080/profile/c0a83801-7f26-15fc-817f-26362da70000'),
     headers: {
       'Authorization':
            'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjMGE4MzgwMS03ZjI2LTE1ZmMtODE3Zi0yNjM2MmRhNzAwMDAiLCJpYXQiOjE2NDU3MDM0MTgsIm5vbWJyZSI6IkphaW1lIiwidXNlclJvbGVzIjoiUFVCTElDTyJ9.aY02jkpbiaqCweBTyRg1cLCqkW9_ZA5Vfo1DlIuR078'});
    if (response.statusCode == 200) {
      return UserData.fromJson(json.decode(response.body)); 
    } else {
      throw Exception('Fail to load users');
    }
  }


}