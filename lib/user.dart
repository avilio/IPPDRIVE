
class User{

  String _session;
  String _username;
  String _password;

  getsession() => _session;
  getusername() => _username;
  getpassword() => _password;

  set session(String value) {
    _session = value;
  }

  set username(String value) {
    _username = value;
  }

  set password(String value) {
    _password = value;
  }
}