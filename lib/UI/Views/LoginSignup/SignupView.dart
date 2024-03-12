import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tfg_v1/Domain/SignUpBloc/sing_up_bloc.dart';
import 'package:tfg_v1/Domain/SignUpBloc/sing_up_event.dart';
import 'package:tfg_v1/Domain/SignUpBloc/sing_up_state.dart';
import 'package:tfg_v1/Domain/NavigatorBloc/navigator_bloc.dart';
import 'package:tfg_v1/Domain/NavigatorBloc/navigator_event.dart';
import 'package:tfg_v1/UI/Utilities/widgets.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor, // Set the background to white
      body: Center(
        child: SingleChildScrollView(
          child: SignUpForm(),
        ),
      ),
    );
  }
}

class SignUpForm extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final SignUpBloc signUpBloc = BlocProvider.of<SignUpBloc>(context);
    final NavigatorBloc navigatorBloc = BlocProvider.of<NavigatorBloc>(context);
    final ThemeData theme = Theme.of(context);
    final TextStyle linkStyle = TextStyle(
      color: theme.colorScheme.secondary,
      fontSize: 16,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.underline,
    );

    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        if (state is SignUpSuccess) {
          navigatorBloc.add(GoToStartInitialConfigutationEvent());
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Good to see you!',
                style: theme.textTheme.headline1, 
              ),
              Text(
                'Add your email and password',
                style: theme.textTheme.titleMedium,
              ),
              SizedBox(height: 20),
              // Email field
              myTransparentTextField(
                controller: emailController, 
                obscureText: false, 
                hintText: "Email", 
                labelText: "Email", 
                keyboardType: TextInputType.emailAddress
              ),           
              SizedBox(height: 20),
              // Password field
              myTransparentTextField(
                controller: passwordController, 
                obscureText: true, 
                hintText: "Password", 
                labelText: "Password", 
                keyboardType: TextInputType.text
              ),
              SizedBox(height: 30),
              // Sign Up button
              ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 200,
                  maxWidth: 300,
                ),
                child: myGreenButton(
                  onPressed: () {
                    final email = emailController.text;
                    final password = passwordController.text;
                    signUpBloc.add(SignUpButtonPressed(email: email, password: password));
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                  decoration: BoxDecoration(),
                  height: 50,
                  width: 50 ,
                ),
              ),
              SizedBox(height: 20),
              // Switch to Sign In
              GestureDetector(
                onTap: () {
                  navigatorBloc.add(GoToLoginEvent());
                },
                child: Text(
                  'Already have an account? Log in here.',
                  style: linkStyle, // Estilo de enlace definido arriba
                ),
              ),
              if (state is SignUpLoading) // Show loading indicator
                CircularProgressIndicator(),
              if (state is SignUpSuccess) // Show success message
                Text('Sign Up Successful!', style: TextStyle(color: theme.primaryColor)),
              if (state is SignUpFailure) // Show failure message
                Text('Sign Up Failed: ${state.error}', style: TextStyle(color: theme.errorColor)),
            ],
          ),
        );
      },
    );
  }
}


class SuccessMessage extends StatelessWidget {
  final String message;

  const SuccessMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: true, // You can use a condition to control visibility
      child: Column(
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 50,
          ),
          SizedBox(height: 20),
          Text(
            message,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}

class FailureMessage extends StatelessWidget {
  final String message;

  const FailureMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: true, // You can use a condition to control visibility
      child: Column(
        children: [
          Icon(
            Icons.error,
            color: Colors.red,
            size: 50,
          ),
          SizedBox(height: 20),
          Text(
            message,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
