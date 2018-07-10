/// Class que guarda campos do user logado
class PaeUser{
  /// Username logado
  String username;
  /// Nome do user logado
  String name;
  /// Sessão do user logado
  String session;
  /// Password do user logado
  String password;
  /// Constructor
  PaeUser(this.username, this.session, this.name,this.password);
  /// Constructor apartir do Json
  PaeUser.fromJson(Map json, {String password})
      : username = json['username'],
        name = json['name'],
        session = json['BACOSESS'],
        password = password ?? "dummy";


}