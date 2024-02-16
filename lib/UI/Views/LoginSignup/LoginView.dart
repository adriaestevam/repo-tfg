import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tfg_v1/Domain/NavigatorBloc/navigator_event.dart';
import 'package:tfg_v1/UI/Utilities/app_colors.dart';
import 'package:tfg_v1/UI/Views/LoginSignup/SignupView.dart';
import 'package:tfg_v1/Domain/NavigatorBloc/navigator_bloc.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final NavigatorBloc navigatorBloc = BlocProvider.of<NavigatorBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
        backgroundColor: AppColors.primary,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.secondary, AppColors.accent],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Hello',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Good to see you',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: InputBorder.none,
                        ),
                      ),
                      const Divider(color: AppColors.text),
                      TextField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: InputBorder.none,
                        ),
                        obscureText: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    // Implement login functionality here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                TextButton(
                  onPressed: () {
                    navigatorBloc.add(SignUpEvent());
                  },
                  child: const Text(
                    'Don\'t have an account? Sign up here.',
                    style: TextStyle(
                      color: AppColors.text,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
