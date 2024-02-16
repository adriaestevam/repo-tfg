import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tfg_v1/Domain/NavigatorBloc/navigator_bloc.dart';
import 'package:tfg_v1/Domain/NavigatorBloc/navigator_state.dart';
import 'package:tfg_v1/Domain/SignUpBloc/sing_up_bloc.dart';
import 'package:tfg_v1/UI/Utilities/AppTheme.dart';
import 'package:tfg_v1/UI/Utilities/Routes.dart';
import 'package:tfg_v1/UI/Views/LoginSignup/LoginView.dart';
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
          BlocProvider<NavigatorBloc>(
            create: (context) => NavigatorBloc(),
          ),
          // Agrega más BlocProviders si es necesario
        ],
        child: MaterialApp(
          title: 'Your App Title',
          theme: AppTheme.getAppTheme(),
          home: BlocBuilder<NavigatorBloc, NaviState>(
            builder: (context, state) {
              if (state is LoginState) {
                return LoginPage();
              } else if (state is SignupState) {
                return SignUpScreen();
              }
              return SignUpScreen(); // Manejo de estado no definido
            },
          ),
          routes: Routes.routes,
        ),
      ),
    );
  }
}


