import 'dart:async';

class Validators {
  ///Usar para TextField
 /* final validateUsername = StreamTransformer<String, String>.fromHandlers(
      handleData: (username, sink) {
    RegExp("[a-zA-Z0-9]{1,256}").hasMatch(username)
        ? sink.add(username)
        : sink.addError('User is not valid');
  });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    password.length < 5
        ? sink.addError('Password too short')
        : sink.add(password);
  });*/

  ///Usar para TextFormField
  String userValidation(String user) =>
      RegExp("[a-zA-Z0-9]{1,256}").hasMatch(user) ? null : 'User is not valid';

  String passwordValidation(String password) =>
      password.length < 5 ? 'Password too short' : null;

}
