import 'package:flutter_miarmapp/models/publicacion_model.dart';

abstract class PublicacionRepository {
  Future<List<PublicacionData>> fetchPublicaciones(String type);
}