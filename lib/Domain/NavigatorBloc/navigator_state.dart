import 'package:meta/meta.dart';

@immutable
abstract class NaviState {}

class NavigatorInitial extends NaviState{}
class LoginState extends NaviState {}
class SignupState extends NaviState {}
class StartInitialConfigutationState extends NaviState{}
