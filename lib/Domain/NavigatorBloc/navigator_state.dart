import 'package:meta/meta.dart';

@immutable
abstract class NaviState {}

class NavigatorInitial extends NaviState{}
class GoToLoginState extends NaviState {}
class GoToSignupState extends NaviState {}
class GoToStartInitialConfigutationState extends NaviState{}
