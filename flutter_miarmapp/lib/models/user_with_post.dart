class UserData {
  UserData({
    required this.id,
    required this.nombre,
    required this.apellidos,
    required this.nick,
    required this.fechaNacimiento,
    required this.email,
    required this.avatar,
    required this.userRoles,
    required this.followers,
    required this.publicaciones,
    required this.peticiones,
  });
  late final String id;
  late final String nombre;
  late final String apellidos;
  late final String nick;
  late final String fechaNacimiento;
  late final String email;
  late final String avatar;
  late final String userRoles;
  late final List<dynamic> followers;
  late final List<Publicaciones> publicaciones;
  late final int peticiones;
  
  UserData.fromJson(Map<String, dynamic> json){
    id = json['id'];
    nombre = json['nombre'];
    apellidos = json['apellidos'];
    nick = json['nick'];
    fechaNacimiento = json['fechaNacimiento'];
    email = json['email'];
    avatar = json['avatar'];
    userRoles = json['userRoles'];
    followers = List.castFrom<dynamic, dynamic>(json['followers']);
    publicaciones = List.from(json['publicaciones']).map((e)=>Publicaciones.fromJson(e)).toList();
    peticiones = json['peticiones'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['nombre'] = nombre;
    _data['apellidos'] = apellidos;
    _data['nick'] = nick;
    _data['fechaNacimiento'] = fechaNacimiento;
    _data['email'] = email;
    _data['avatar'] = avatar;
    _data['userRoles'] = userRoles;
    _data['followers'] = followers;
    _data['publicaciones'] = publicaciones.map((e)=>e.toJson()).toList();
    _data['peticiones'] = peticiones;
    return _data;
  }
}

class Publicaciones {
  Publicaciones({
    required this.id,
    required this.titulo,
    required this.texto,
    required this.file,
    required this.fechaPublicacion,
    required this.estadoPublicacion,
  });
  late final int id;
  late final String titulo;
  late final String texto;
  late final String file;
  late final String fechaPublicacion;
  late final String estadoPublicacion;
  
  Publicaciones.fromJson(Map<String, dynamic> json){
    id = json['id'];
    titulo = json['titulo'];
    texto = json['texto'];
    file = json['file'];
    fechaPublicacion = json['fechaPublicacion'];
    estadoPublicacion = json['estadoPublicacion'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['titulo'] = titulo;
    _data['texto'] = texto;
    _data['file'] = file;
    _data['fechaPublicacion'] = fechaPublicacion;
    _data['estadoPublicacion'] = estadoPublicacion;
    return _data;
  }
}