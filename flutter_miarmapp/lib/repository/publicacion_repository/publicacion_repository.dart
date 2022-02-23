import 'package:flutter_miarmapp/models/publicaciones/publicaciones_response.dart';

abstract class PublicacionRepository {
  Future<List<Publicacion>> fetchMovies(String type);
}