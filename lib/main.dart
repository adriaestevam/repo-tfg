import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tfg_v1/Data/DataService.dart';
import 'package:tfg_v1/Domain/LoginBloc/login_bloc.dart';
import 'package:tfg_v1/Domain/NavigatorBloc/navigator_bloc.dart';
import 'package:tfg_v1/Domain/NavigatorBloc/navigator_event.dart';
import 'package:tfg_v1/Domain/NavigatorBloc/navigator_state.dart';
import 'package:tfg_v1/Domain/SignUpBloc/sing_up_bloc.dart';
import 'package:tfg_v1/UI/Utilities/AppTheme.dart';
import 'package:tfg_v1/UI/Utilities/Routes.dart';
import 'package:tfg_v1/UI/Utilities/bottom_nav_bar_state.dart';
import 'package:tfg_v1/UI/Views/Initial%20Configuration/initial_configuration.dart';
import 'package:tfg_v1/UI/Views/LoginSignup/LoginView.dart';
import 'package:tfg_v1/UI/Views/LoginSignup/SignupView.dart';
import 'package:tfg_v1/UI/Views/home_page.dart';
import 'package:tfg_v1/UI/Views/notification_page.dart';
import 'package:tfg_v1/UI/Views/objectives_page.dart';
import 'package:tfg_v1/UI/Views/subjects_page.dart';
import 'Data/AuthRepository.dart';
import 'Data/DataService.dart';
import 'UI/Views/Initial Configuration/addNewSubject.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(DataService()),
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
          BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(
              authRepository: RepositoryProvider.of<AuthRepository>(context),
            ),
          ),          
          // Agrega más BlocProviders si es necesario
        ],
        child: ChangeNotifierProvider<BottomNavBarState>(
          create: (context) => BottomNavBarState(),
          child: MaterialApp(
            title: 'Your App Title',
            theme: AppTheme.getAppTheme(),
            home: BlocBuilder<NavigatorBloc, NaviState>(
              builder: (context, state) {
                print("Current state is ");
                print(state);
                if (state is GoToLoginState) {
                  return LoginScreen();
                } else if (state is GoToSignupState) {
                  return SignUpScreen();
                } else if (state is GoToStartInitialConfigutationState){
                  return InitialConfigurationScreen();
                } else if(state is GoToHomeState){
                  return HomeScreen();
                } else if(state is GoToObjectivesState){
                  return ObjectivesScreen();
                } else if (state is GoToNotificationsState){
                  return NotificationsScreen();
                } else if (state is GoToSubjectsState){
                  return SubjectsScreen();
                }
                return LoginScreen(); // Manejo de estado no definido
              },
            ),
          ),
        )
      ),
    );
  }
}