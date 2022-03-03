import 'dart:convert';
import 'package:flutter_miarmapp/models/publicacion_dto.dart';
import 'package:flutter_miarmapp/models/publicacion_model.dart';
import 'package:flutter_miarmapp/repository/constants.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'publicacion_repository.dart';

class PublicacionRepositoryImpl extends PublicacionRepository {
  final Client _client = Client();

  @override
  Future<List<PublicacionData>> fetchPublicaciones(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await _client.get(
        Uri.parse('http://10.0.2.2:8080/post/${Constant.nowPlaying}'),
        headers: {'Authorization': 'Bearer ${prefs.getString('token')}'});
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((i) => PublicacionData.fromJson(i))
          .toList();
    } else {
      throw Exception('Fail to load movies');
    }
  }

  @override
  Future<PublicacionData> createPublicacion(
      PublicacionDto dto, String image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, String> pepe = {
      'Authorization': 'Bearer ${prefs.getString('token')}',
    };

    var uri = Uri.parse('http://10.0.2.2:8080/post/');
    var request = http.MultipartRequest('POST', uri);
    request.fields['titulo'] = prefs.getString('titulo').toString();
    request.fields['texto'] = prefs.getString('texto').toString();
    request.fields['estadoPublicacion'] = true.toString();
    request.files.add(await http.MultipartFile.fromPath(
        'file', prefs.getString('file').toString()));
    request.headers.addAll(pepe);

    var response = await request.send();
    if (response.statusCode == 201) print('Uploaded!');

    if (response.statusCode == 201) {
      return PublicacionData.fromJson(
          jsonDecode(await response.stream.bytesToString()));
    } else {
      print(response.statusCode);
      throw Exception(prefs.getString('titulo'));
    }
  }
}
