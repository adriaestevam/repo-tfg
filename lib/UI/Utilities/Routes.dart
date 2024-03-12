import 'package:flutter/material.dart';
import 'package:tfg_v1/UI/Views/LoginSignup/LoginView.dart';
import 'package:tfg_v1/UI/Views/LoginSignup/SignupView.dart';
import 'package:tfg_v1/UI/Views/Home/home_page.dart';

class Routes {
  static const String login = '/login';
  static const String home = '/home';
  static const String signup ='/signup';

  static final Map<String, WidgetBuilder> routes = {
    login: (context) => LoginScreen(),
    signup: (context) => SignUpScreen()
  };
}
