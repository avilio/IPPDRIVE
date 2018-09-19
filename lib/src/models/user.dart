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
  /// Ano Corrent
  String anoCorrente;

  /// Constructor
  PaeUser(this.username, this.session, this.name,this.password, this.anoCorrente);
  /// Constructor apartir do Json
  PaeUser.fromJson(Map json, {String password, String anoCorrente})
      : username = json['username'],
        name = json['name'],
        session = json['BACOSESS'],
        password = password ?? "dummy",
        anoCorrente = anoCorrente ?? DateTime.now().year;

  @override
  String toString() {
    return '{username: $username, name: $name, session: $session, password: $password, anoCorrent: $anoCorrente}';
  }


}