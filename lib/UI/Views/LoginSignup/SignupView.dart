import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      body: BlocProvider(
        create: (context) => SignUpBloc(),
        child: SignUpForm(),
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

    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        if (state is SignUpLoading) {
          // Show loading screen
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is SignUpSuccess) {
          // Show success message and icon
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 50,
                ),
                SizedBox(height: 20),
                Text(
                  'Sign Up Successful!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          );
        } else {
          // Default form for initial state and SignUpFailure
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
              ],
            ),
          );
        }
      },
    );
  }
}
