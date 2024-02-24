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
    final ThemeData theme = Theme.of(context);
    final TextStyle linkStyle = TextStyle(
      color: theme.colorScheme.secondary,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );

    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state is LoginSucess) {
          navigatorBloc.add(GoToHomeEvent());
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Log In',
                style: theme.textTheme.headline1,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.primaryColor, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.colorScheme.secondary, width: 2.0),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.primaryColor, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.colorScheme.secondary, width: 2.0),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final email = _emailController.text;
                  final password = _passwordController.text;
                  loginBloc.add(LoginButtonPressed(email,password));
                },
                child: Text('Log In'),
              ),
              if (state is LoginLoading) CircularProgressIndicator(),
              if (state is LoginFailure) Text(
                state.error,
                style: TextStyle(color: theme.errorColor),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  navigatorBloc.add(GoToSignUpEvent());
                },
                child: Text('Don\'t have an account? Sign up here.', style: linkStyle),
              ),
            ],
          ),
        );
      },
    );
  }
}


