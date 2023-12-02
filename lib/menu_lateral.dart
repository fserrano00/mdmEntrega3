import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyectomdm/Chat2/userListScreen.dart';
import 'package:proyectomdm/calendario_global.dart';

import 'package:proyectomdm/firebase_service.dart';
import 'package:proyectomdm/main_page.dart';
import 'package:proyectomdm/registro_doctor.dart';

class SidebarMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? getCurrentUser() {
      return FirebaseAuth.instance.currentUser;
    }

    User? user = getCurrentUser();

    return Drawer(
      child: FutureBuilder(
        future: getUsuarios(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No se encontraron datos de usuario.'));
          } else {
            List<Map<String, dynamic>> userDataList =
                List<Map<String, dynamic>>.from(snapshot.data as List<dynamic>);
            if (userDataList.isNotEmpty) {
              var userData = userDataList[0];
              var accountName = user?.displayName ?? userData['nombre'];
              var accountEmail = user?.email ?? userData['Correo'];
              var accountUID = FirebaseAuth.instance.currentUser!
                  .uid; // Suponiendo que el campo se llama 'Correo'

              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text(accountUID),
                    accountEmail: Text(accountEmail),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(accountName?[0] ?? ''),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text('Inicio'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.upgrade),
                    title: Text('Registrarse como Doctor'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistroDoctor()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.calendar_month),
                    title: Text('Tus citas'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CalendarioCitas()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.message),
                    title: Text('Chat'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UsersListScreen(
                                  currentUserId:
                                      FirebaseAuth.instance.currentUser!.uid,
                                )),
                      );
                    },
                  ),
                ],
              );
            } else {
              return Center(child: Text('No se encontraron datos de usuario.'));
            }
          }
        },
      ),
    );
  }
}
