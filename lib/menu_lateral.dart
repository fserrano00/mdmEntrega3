import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proyectomdm/firebase_service.dart';

class SidebarMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              var accountName = userData['Nombre'];
              var accountEmail = userData[
                  'Correo']; // Suponiendo que el campo se llama 'Correo'

              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text(accountName),
                    accountEmail: Text(accountEmail),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(accountName[0]),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text('Inicio'),
                    onTap: () {
                      Navigator.pop(context);
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
