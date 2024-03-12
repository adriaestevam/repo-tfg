import 'package:meta/meta.dart';

@immutable
abstract class LoginEvent{}

class setLoginInitial extends LoginEvent{}

class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;

  LoginButtonPressed(this.email, this.password);
}
