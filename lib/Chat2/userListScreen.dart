import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyectomdm/Chat2/sender_Chat.dart';

class UsersListScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final String currentUserId;

  UsersListScreen({required this.currentUserId});

  Future<String?> _getOtherUserUid(String userEmail) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Clientes')
        .where('nombre', isEqualTo: userEmail)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    }

    return null;
  }

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
              var userEmail = user['nombre'];

              return ListTile(
                title: Text(userEmail),
                onTap: () {
                  _getOtherUserUid(userEmail).then((otherUserUid) {
                    if (otherUserUid != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            currentUserId: currentUserId,
                            otherUserId: otherUserUid,
                          ),
                        ),
                      );
                    } else {
                      print('Usuario no encontrado');
                      // Manejar caso en que el usuario no sea encontrado
                    }
                  });
                },
              );
            },
          );
        },
      ),
    );
  }
}
