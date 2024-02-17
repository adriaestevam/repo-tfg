import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tfg_v1/Domain/SignUpBloc/sing_up_bloc.dart';
import 'package:tfg_v1/Domain/SignUpBloc/sing_up_event.dart';
import 'package:tfg_v1/Domain/SignUpBloc/sing_up_state.dart';
import 'package:tfg_v1/Domain/NavigatorBloc/navigator_bloc.dart';
import 'package:tfg_v1/Domain/NavigatorBloc/navigator_event.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background to white
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

    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        if(state is SignUpSuccess){
          navigatorBloc.add(StartInitialConfigutationEvent());
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Create Account',
                style: TextStyle(
                  color: Colors.blue.shade800, // Adjust the color to match the image
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              // Email field
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Your Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.blue.shade50,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              // Password field
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.blue.shade50,
                ),
                obscureText: true,
              ),
              SizedBox(height: 40),
              // Sign Up button
              ElevatedButton(
                onPressed: () {
                  final email = emailController.text;
                  final password = passwordController.text;
                  signUpBloc.add(SignUpButtonPressed(email: email, password: password));
                },
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue.shade800, // Adjust the button color to match the image
                  onPrimary: Colors.white,
                  shape: StadiumBorder(),
                  padding: EdgeInsets.symmetric(horizontal: 120, vertical: 15),
                ),
              ),
              SizedBox(height: 20),
              // Switch to Sign In
              GestureDetector(
                onTap: () {
                  navigatorBloc.add(LoginEvent());
                },
                child: Text(
                  'Already have an account? Sign in here.',
                  style: TextStyle(
                    color: Colors.blue.shade800, // Adjust the color to match the image
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              if (state is SignUpLoading) // Show loading indicator
                CircularProgressIndicator(),
              if (state is SignUpSuccess) // Show success message
                Text('Sign Up Successful!'),
              if (state is SignUpFailure) // Show failure message
                Text('Sign Up Failed: ${state.error}'),
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
