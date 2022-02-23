import 'dart:convert';
import 'package:flutter_miarmapp/models/publicaciones/publicaciones_response.dart';
import 'package:flutter_miarmapp/repository/publicacion_repository/publicacion_repository.dart';
import 'package:http/http.dart';
import '../constants.dart';

class MovieRepositoryImpl extends PublicacionRepository {
  final Client _client = Client();

  @override
  Future<List<Publicacion>> fetchMovies(String type) async {
    final response = await _client.get(Uri.parse('https://api.themoviedb.org/3/movie/$type?api_key=${Constant.apiKey}'));
    if (response.statusCode == 200) {
      return MoviesResponse.fromJson(json.decode(response.body)).results;
    } else {
      throw Exception('Fail to load movies');
    }
  }
}