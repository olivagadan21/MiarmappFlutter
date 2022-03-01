class LoginResponse {
  LoginResponse({
    required this.id,
    required this.nick,
    required this.email,
    required this.nombre,
    required this.avatar,
    required this.role,
    required this.token,
  });
  late final String id;
  late final String nick;
  late final String email;
  late final String nombre;
  late final String avatar;
  late final String role;
  late final String token;
  
  LoginResponse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    nick = json['nick'];
    email = json['email'];
    nombre = json['nombre'];
    avatar = json['avatar'];
    role = json['role'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['nick'] = nick;
    _data['email'] = email;
    _data['nombre'] = nombre;
    _data['avatar'] = avatar;
    _data['role'] = role;
    _data['token'] = token;
    return _data;
  }
}