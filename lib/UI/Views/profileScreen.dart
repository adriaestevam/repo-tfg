import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tfg_v1/Domain/NavigatorBloc/navigator_event.dart';
import 'package:tfg_v1/Domain/UserBloc/user_event.dart';
import 'package:tfg_v1/Domain/UserBloc/user_state.dart';
import 'package:tfg_v1/UI/Utilities/AppTheme.dart';
import 'package:tfg_v1/UI/Utilities/widgets.dart';
import 'package:tfg_v1/UI/Utilities/widgets.dart';

import '../../Data/Models/Users.dart';
import '../../Domain/NavigatorBloc/navigator_bloc.dart';
import '../../Domain/UserBloc/user_bloc.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final NavigatorBloc navigatorBloc = BlocProvider.of<NavigatorBloc>(context);
    final UserBloc userBloc = BlocProvider.of<UserBloc>(context);


      return BlocBuilder<UserBloc,UserState>(builder: (context, state) {
        if(state is displayInformation){
          return Scaffold(
            appBar: AppBar(
              backgroundColor: backgroundColor,
              title: Text('Profile'),
              actions: [
                Container(
                  decoration: myBoxDecoration(),
                  constraints: BoxConstraints(
                    maxHeight: 40,
                    maxWidth: 40
                  ),
                  child: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditProfileScreen(user: state.user)), // Reemplaza PerfilScreen() con el nombre de tu pantalla de perfil
                      );
                    },
                  ),
                ),
                SizedBox(width: 20,)
              ],
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: myBoxDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: secondaryTextColor,
                              size: 24,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Username:',
                              style: TextStyle(
                                fontSize: 18,
                                color: secondaryTextColor,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          state.user.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: secondaryTextColor,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.email,
                              color: secondaryTextColor,
                              size: 24,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Email:',
                              style: TextStyle(
                                fontSize: 18,
                                color: secondaryTextColor,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          state.user.email,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: myBoxDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'University',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(
                              Icons.school,
                              color: secondaryTextColor,
                              size: 24,
                            ),
                            SizedBox(width: 10),
                            Text(
                              state.university.name,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: secondaryTextColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: myBoxDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Subjects',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        SizedBox(height: 20),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.subjects.length,
                          itemBuilder: (context, index) {
                            final subject = state.subjects[index];
                            return Container(
                              margin: EdgeInsets.only(bottom: 10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300, 
                                borderRadius: BorderRadius.circular(12), 
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade500,
                                    offset: Offset(5.00, 5.00),
                                    blurRadius: 10,
                                    spreadRadius: 0.5,
                                    inset: true,
                                  ),
                                  BoxShadow(
                                    color: Colors.white,
                                    offset: Offset(-5.00, -5.00),
                                    blurRadius: 10,
                                    spreadRadius: 0.5,
                                    inset: true,
                                  ),
                                ],
                                
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    subject.name,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    '${subject.credits} credits',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  myGreenButton(
                    onPressed: () {
                      print("object");
                      navigatorBloc.add(GoToLoginEvent());
                      Navigator.pop(context);
                    },
                    decoration: myBoxDecoration(), 
                    height: 55, 
                    width: 70,
                    child: Text('Log out',style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            ),
          );


        } else {
          userBloc.add(loadUserProfileInformation());
          return Scaffold(
            appBar: AppBar(
              title: Text('Cargando datos de usuario'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(), // Icono de carga
                  SizedBox(height: 20),
                  Text(
                    'Cargando datos de usuario...',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          );

        }        
      },
    );
  }
}
class EditProfileScreen extends StatelessWidget {
  final User user;

  EditProfileScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    String initialName = user.name;
    String initialMail = user.email;
    String initialPassword = user.password;
    final UserBloc userBloc = BlocProvider.of<UserBloc>(context);


    // Variables para almacenar los valores actuales de los campos de texto
    late String currentName = '';
    late String currentMail = '';
    late String currentPassword = '';

    return BlocBuilder<UserBloc,UserState>(
      builder: (context,state){
        return Scaffold(
          appBar: AppBar(
            title: Text('Edit Profile'),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  initialValue: initialName, // Nombre del usuario
                  decoration: InputDecoration(labelText: 'Name'),
                  onChanged: (value) {
                    currentName = value; // Actualizar el valor actual del nombre
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: initialMail, // Correo electrónico del usuario
                  decoration: InputDecoration(labelText: 'Email'),
                  onChanged: (value) {
                    currentMail = value; // Actualizar el valor actual del correo electrónico
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: initialPassword,
                  decoration: InputDecoration(labelText: 'Password'),
                  onChanged: (value) {
                    currentPassword = value; // Actualizar el valor actual de la contraseña
                  },
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: myGreenButton(
                        onPressed:  () {
                      
                          // Comparar los valores actuales con los valores iniciales
                          if (
                            currentName != initialName && currentName != '' || 
                            currentMail != initialMail && currentMail != '' ||
                            currentPassword != initialPassword  && currentPassword != ''
                          ) {

                          userBloc.add(updateUser(
                            user: user, 
                            currentName: currentName, 
                            currentMail: currentMail, 
                            currentPassword: currentPassword
                          ));

                          }
                          else {
                            print('No changes detected');
                          }
                          userBloc.add(loadUserProfileInformation());
                          Navigator.pop(context);

                        }, 
                        child: Text("Save Changes",style: TextStyle(color: Colors.white),), 
                        decoration: myBoxDecoration(), 
                        height: 50, 
                        width: 50
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: myTransparentButton(
                        onPressed:  () {
                          Navigator.pop(context);
                        }, 
                        child: Text("Cancel",style: TextStyle(color: accentColor),), 
                        decoration: myBoxDecoration(), 
                        height: 50, 
                        width: 50
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
