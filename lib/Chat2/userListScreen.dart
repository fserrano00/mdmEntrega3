import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyectomdm/Chat2/sender_Chat.dart';

class UsersListScreen extends StatelessWidget {
  final String currentUserId;

  UsersListScreen({required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose a User'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Clientes').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          List<DocumentSnapshot> users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              var userId = user.id;
              var userEmail = user[
                  'nombre']; // Supongamos que 'email' es el campo que contiene el correo del usuario

              return ListTile(
                title: Text(userEmail),
                onTap: () {
                  // Al hacer clic en un usuario, abrir la pantalla de chat con ese usuario
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatMessagesScreen(
                        currentUserId: userId,
                        chatId: userId,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
