import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tfg_v1/Domain/LoginBloc/login_bloc.dart';
import 'package:tfg_v1/Domain/LoginBloc/login_event.dart';
import 'package:tfg_v1/Domain/LoginBloc/login_state.dart';
import 'package:tfg_v1/Domain/NavigatorBloc/navigator_bloc.dart';
import 'package:tfg_v1/Domain/NavigatorBloc/navigator_event.dart';
import 'package:tfg_v1/Domain/NavigatorBloc/navigator_state.dart';



class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: LoginForm(),
        ),
      ),
    );
  }
}
class LoginForm extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final NavigatorBloc navigatorBloc = BlocProvider.of<NavigatorBloc>(context);
    final LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);

    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if(state is LoginSucess){
          navigatorBloc.add(GoToStartInitialConfigutationEvent());
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Log In',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final email = _emailController.text;
                  final password = _passwordController.text;
                  loginBloc.add(LoginButtonPressed(email, password));
                },
                child: Text('Log In'),
              ),
              // Mostrar indicador de carga si el estado es LoginLoading
              if (state is LoginLoading) CircularProgressIndicator(),
              // Mostrar mensaje de error si el estado es LoginFailure
              if (state is LoginFailure) Text(
                state.error,
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  navigatorBloc.add(GoToSignUpEvent());
                },
                child: Text('Don\'t have an account? Sign up here.'),
              ),
            ],
          ),
        );
      },
    );
  }
}

