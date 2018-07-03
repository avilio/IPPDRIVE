/// Class que guarda campos do user logado
class PaeUser{
  /// Username logado
  String username;
  /// Nome do user logado
  String name;
  /// Sessão do user logado
  String session;
  /// Constructor
  PaeUser(this.username, this.session, this.name);
  /// Constructor apartir do Json
  PaeUser.fromJson(Map json)
      : username = json['username'],
        name = json['name'],
        session = json['BACOSESS'];

}