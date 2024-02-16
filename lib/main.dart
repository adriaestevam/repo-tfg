import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tfg_v1/Domain/SignUpBloc/sing_up_bloc.dart';
import 'package:tfg_v1/UI/Views/LoginSignup/SignupView.dart';

import 'Data/AuthRepository.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(),
        ),
        // Agrega más RepositoryProviders según sea necesario
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SignUpBloc>(
            create: (context) => SignUpBloc(
              authRepository: RepositoryProvider.of<AuthRepository>(context),
            ),
          ),
          // Agrega más BlocProviders si es necesario
        ],
        child: MaterialApp(
          title: 'Your App Title',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            // Add any other theme configurations here
          ),
          home: SignUpScreen(), // Replace with the actual widget for your sign-up view
        ),
      ),
    );
  }
}
