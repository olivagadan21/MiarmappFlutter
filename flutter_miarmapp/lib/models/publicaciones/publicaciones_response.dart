class Publicacion {
  Publicacion({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fichero,
    required this.ficheroMob,
    required this.perfil,
    required this.usernamePropietario,
  });
  late final int id;
  late final String titulo;
  late final String descripcion;
  late final String fichero;
  late final String ficheroMob;
  late final String perfil;
  late final String usernamePropietario;
  
  Publicacion.fromJson(Map<String, dynamic> json){
    id = json['id'];
    titulo = json['titulo'];
    descripcion = json['descripcion'];
    fichero = json['fichero'];
    ficheroMob = json['ficheroMob'];
    perfil = json['perfil'];
    usernamePropietario = json['usernamePropietario'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['titulo'] = titulo;
    _data['descripcion'] = descripcion;
    _data['fichero'] = fichero;
    _data['ficheroMob'] = ficheroMob;
    _data['perfil'] = perfil;
    _data['usernamePropietario'] = usernamePropietario;
    return _data;
  }
}