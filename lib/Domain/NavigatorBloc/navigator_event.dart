import 'package:meta/meta.dart';

@immutable
abstract class NavigatorEvent{}

class SignUpEvent extends NavigatorEvent {}
class LoginEvent extends NavigatorEvent {}