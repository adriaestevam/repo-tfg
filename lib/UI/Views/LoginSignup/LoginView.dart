import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tfg_v1/Domain/LoginBloc/login_bloc.dart';
import 'package:tfg_v1/Domain/LoginBloc/login_event.dart';
import 'package:tfg_v1/Domain/LoginBloc/login_state.dart';
import 'package:tfg_v1/Domain/NavigatorBloc/navigator_bloc.dart';
import 'package:tfg_v1/Domain/NavigatorBloc/navigator_event.dart';
import 'package:tfg_v1/Domain/NavigatorBloc/navigator_state.dart';
import 'package:tfg_v1/UI/Utilities/widgets.dart';



class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
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
                'Welcome back',
                style: theme.textTheme.headline1,
              ),
              Text(
                'Good to see you again!',
                style: theme.textTheme.titleMedium ,
              ),
              SizedBox(height: 20),
              myTransparentTextField(
                controller: _emailController, 
                keyboardType: TextInputType.emailAddress, 
                obscureText: false, 
                hintText: "Email", 
                labelText: "Email"
              ),
              SizedBox(height: 20),
              myTransparentTextField(
                controller: _passwordController, 
                obscureText: true, 
                hintText: 'Password', 
                labelText: 'Password', 
                keyboardType: TextInputType.name
                ),
              SizedBox(height: 20),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 200, // Minimum width
                  maxWidth: 300, // Maximum width
                ),
                child: myGreenButton(
                  onPressed: () {
                    final email = _emailController.text;
                    final password = _passwordController.text;
                    loginBloc.add(LoginButtonPressed(email, password));
                  },
                  child: const Text(
                    'Log In',
                    style: TextStyle(color: Colors.white),
                  ),
                  decoration: BoxDecoration(),
                ),
              ),
              SizedBox(height: 40,),
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


