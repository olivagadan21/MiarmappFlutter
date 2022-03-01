import 'dart:convert';

import 'package:flutter_miarmapp/models/publicacion_model.dart';
import 'package:flutter_miarmapp/repository/constants.dart';
import 'package:http/http.dart';

import 'publicacion_repository.dart';

class PublicacionRepositoryImpl extends PublicacionRepository {
  final Client _client = Client();

/*List<PublicacionData> myModels;
var response = await http.get("myUrl");

myModels=(json.decode(response.body) as List).map((i) =>
              MyModel.fromJson(i)).toList();*/

  @override
  Future<List<PublicacionData>> fetchPublicaciones(String type) async {
    final response = await _client.get(Uri.parse('http://10.0.2.2:8080/post/${Constant.nowPlaying}'),
     headers: {
       'Authorization':
            'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjMGE4MzgwMS03ZjI2LTE1ZmMtODE3Zi0yNjM2MmRhNzAwMDAiLCJpYXQiOjE2NDU3MDM0MTgsIm5vbWJyZSI6IkphaW1lIiwidXNlclJvbGVzIjoiUFVCTElDTyJ9.aY02jkpbiaqCweBTyRg1cLCqkW9_ZA5Vfo1DlIuR078'});
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List).map((i) =>
              PublicacionData.fromJson(i)).toList();
    } else {
      throw Exception('Fail to load movies');
    }
  }
}