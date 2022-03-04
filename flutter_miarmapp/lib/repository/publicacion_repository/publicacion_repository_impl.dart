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
        Uri.parse('${Constant.baseUrl}/post/${Constant.posts}'),
        headers: {'Authorization': 'Bearer ${prefs.getString('token')}'});
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((i) => PublicacionData.fromJson(i))
          .toList();
    } else {
      throw Exception('Fail to load posts');
    }
  }

  @override
  Future<PublicacionData> createPublicacion(
      PublicacionDto dto, String image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, String> auth = {
      'Authorization': 'Bearer ${prefs.getString('token')}',
    };
    var uri = Uri.parse('${Constant.baseUrl}/post/');
    var request = http.MultipartRequest('POST', uri);
    request.fields['titulo'] = dto.titulo.toString();
    request.fields['texto'] = dto.texto.toString();
    request.fields['estadoPublicacion'] = dto.estadoPublicacion.toString();
    request.files.add(await http.MultipartFile.fromPath(
        'file', prefs.getString('file').toString()));
    request.headers.addAll(auth);
    var response = await request.send();
    if (response.statusCode == 201) print('Uploaded!');

    if (response.statusCode == 201) {
      return PublicacionData.fromJson(
          jsonDecode(await response.stream.bytesToString()));
    } else {
      print(response.statusCode);
      throw Exception('Ojo cuidao que te has equivocado');
    }
  }
}
