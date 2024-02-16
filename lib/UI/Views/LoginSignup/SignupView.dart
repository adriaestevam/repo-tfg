import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tfg_v1/Domain/NavigatorBloc/navigator_bloc.dart';
import 'package:tfg_v1/Domain/NavigatorBloc/navigator_event.dart';
import 'package:tfg_v1/Domain/SignUpBloc/sing_up_event.dart';
import 'package:tfg_v1/Domain/SignUpBloc/sing_up_state.dart';
import '../../../Domain/SignUpBloc/sing_up_bloc.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: SignUpForm()
    );
  }
}


class SignUpForm extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final SignUpBloc signUpBloc = BlocProvider.of<SignUpBloc>(context);
    final NavigatorBloc navigatorBloc= BlocProvider.of<NavigatorBloc>(context);

    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return Container(
          color: Colors.white,
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  final email = emailController.text;
                  final password = passwordController.text;
                  signUpBloc.add(
                    SignUpButtonPressed(email: email, password: password),
                  );
                },
                child: Text('Sign Up'),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  navigatorBloc.add(
                    LoginEvent(),
                  );
                },
                child: Text('Log in'),
              ),
              SizedBox(height: 20.0),
              if (state is SignUpLoading) // Show loading indicator
                CircularProgressIndicator(),
              if (state is SignUpSuccess) // Show success message
                SuccessMessage(message: 'Sign Up Successful!'),
              if (state is SignUpFailure) // Show failure message
                FailureMessage(message: 'Sign Up Failed: ${state.error}'),
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
