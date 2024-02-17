import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tfg_v1/Domain/NavigatorBloc/navigator_bloc.dart';
import 'package:tfg_v1/Domain/NavigatorBloc/navigator_event.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final NavigatorBloc navigatorBloc = BlocProvider.of<NavigatorBloc>(context);

    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco como en SignUpScreen
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    color: Colors.blue.shade800, // El mismo azul que SignUpScreen
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                // Campo de Email
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Your Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.blue.shade50, // El mismo color de fondo que SignUpScreen
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20),
                // Campo de Password
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.blue.shade50, // El mismo color de fondo que SignUpScreen
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 40),
                // Botón de Log in
                ElevatedButton(
                  onPressed: () {
                    // Implementar funcionalidad de login aquí
                  },
                  child: Text(
                    'Log in',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue.shade800, // El mismo color que SignUpScreen
                    onPrimary: Colors.white,
                    shape: StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 120, vertical: 15),
                  ),
                ),
                SizedBox(height: 20),
                // Enlace para registrarse
                GestureDetector(
                  onTap: () {
                    navigatorBloc.add(SignUpEvent());
                  },
                  child: Text(
                    'Don\'t have an account? Sign up here.',
                    style: TextStyle(
                      color: Colors.blue.shade800, // El mismo color que SignUpScreen
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                // Añadir SuccessMessage y FailureMessage si es necesario
              ],
            ),
          ),
        ),
      ),
    );
  }
}
