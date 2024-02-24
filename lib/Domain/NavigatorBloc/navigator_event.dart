import 'package:meta/meta.dart';

@immutable
abstract class NavigatorEvent{}

class GoToSignUpEvent extends NavigatorEvent {}
class GoToLoginEvent extends NavigatorEvent {}
class GoToStartInitialConfigutationEvent extends NavigatorEvent{}
class GoToHomeEvent extends NavigatorEvent{}