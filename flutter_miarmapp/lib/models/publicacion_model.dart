class PublicacionData {
  PublicacionData({
    required this.id,
    required this.titulo,
    required this.texto,
    required this.file,
    required this.fechaPublicacion,
    required this.estadoPublicacion,
    required this.user,
  });
  late final int id;
  late final String titulo;
  late final String texto;
  late final String file;
  late final String fechaPublicacion;
  late final String estadoPublicacion;
  late final User user;

  PublicacionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titulo = json['titulo'];
    texto = json['texto'];
    file = json['file'];
    fechaPublicacion = json['fechaPublicacion'];
    estadoPublicacion = json['estadoPublicacion'];
    user = User.fromJson(json['user']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['titulo'] = titulo;
    _data['texto'] = texto;
    _data['file'] = file;
    _data['fechaPublicacion'] = fechaPublicacion;
    _data['estadoPublicacion'] = estadoPublicacion;
    _data['user'] = user.toJson();
    return _data;
  }
}

class User {
  User({
    required this.id,
    required this.nombre,
    required this.apellidos,
    required this.nick,
    required this.fechaNacimiento,
    required this.email,
    required this.avatar,
    required this.userRoles,
  });
  late final String id;
  late final String nombre;
  late final String apellidos;
  late final String nick;
  late final String fechaNacimiento;
  late final String email;
  late final String avatar;
  late final String userRoles;

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nombre = json['nombre'];
    apellidos = json['apellidos'];
    nick = json['nick'];
    fechaNacimiento = json['fechaNacimiento'];
    email = json['email'];
    avatar = json['avatar'];
    userRoles = json['userRoles'];
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
    return _data;
  }
}
