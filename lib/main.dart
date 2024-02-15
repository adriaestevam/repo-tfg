import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tfg_v1/Domain/SignUpBloc/sing_up_bloc.dart';
import 'package:tfg_v1/UI/Views/LoginSignup/SignupView.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpBloc(),
      child: MaterialApp(
        title: 'Your App Title',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          // Add any other theme configurations here
        ),
        home: SignUpScreen(), // Replace with the actual widget for your sign-up view
      ),
    );
  }
}
