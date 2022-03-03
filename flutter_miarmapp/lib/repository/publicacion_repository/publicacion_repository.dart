import 'package:flutter_miarmapp/models/publicacion_dto.dart';
import 'package:flutter_miarmapp/models/publicacion_model.dart';

abstract class PublicacionRepository {
  Future<List<PublicacionData>> fetchPublicaciones(String type);
  Future<PublicacionData> createPublicacion(PublicacionDto dto, String image);
}
