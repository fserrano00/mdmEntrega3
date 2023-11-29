import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyectomdm/Chat2/userListScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore Chat',
      home: FutureBuilder(
        future: _getCurrentUserEmail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error occurred: ${snapshot.error}'),
            );
          }

          // Se asume que snapshot.data contiene el email del usuario
          return UsersListScreen(currentUserId: snapshot.data as String);
        },
      ),
    );
  }

  Future<String?> _getCurrentUserEmail() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return currentUser.email ?? '';
    }
    return null;
  }
}

///

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final String otherUserId;

  ChatScreen(
      {required this.currentUserId,
      required this.otherUserId}); // Agrega el parámetro otherUserId

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Chat'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .where('chatters', arrayContains: widget.currentUserId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData ||
                    (snapshot.data?.docs.isEmpty ?? true)) {
                  return Center(
                    child: Text('No chats found for the user.'),
                  );
                }

                List<QueryDocumentSnapshot> chats = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    var chat = chats[index];
                    var chatId = chat.id;
                    var lastModified = chat['lastModifiedAt'] ?? '';
                    var messagesCount =
                        chat['chatters'] != null ? chat['chatters'].length : 0;

                    return ListTile(
                      title: Text(chatId),
                      subtitle: Text(
                          'Última modificación: $lastModified\nNúmero de mensajes: $messagesCount'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatMessagesScreen(
                              currentUserId: widget.currentUserId,
                              chatId: chatId,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Enter your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _startChat2, // Llama a la función _sendMessage2
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // void _sendMessage2() {
  //   String messageText = _textController.text;

  //   if (messageText.isNotEmpty) {
  //     _firestore.collection('chats').add({
  //       'chatters': [
  //         widget.currentUserId,
  //         widget.otherUserId
  //       ], // Correos electrónicos de los usuarios
  //       'lastModifiedAt': DateTime.now(),
  //       'messages': [
  //         {
  //           'content': messageText,
  //           'senderId': widget.currentUserId,
  //           'createdAt': DateTime.now(),
  //         },
  //       ],
  //     });

  //     _textController.clear();
  //   }
  // }

  void _startChat2() async {
    String messageText = _textController.text;

    if (messageText.isNotEmpty) {
      var currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        String currentEmail = currentUser.email ?? '';

        String otherUserEmail = await _getOtherUserEmail(widget.otherUserId);

        if (otherUserEmail.isNotEmpty) {
          String chatId = _generateChatId(currentEmail, otherUserEmail);

          _firestore.collection('chats').doc(chatId).set({
            'chatters': [currentEmail, otherUserEmail],
            'lastModifiedAt': DateTime.now(),
          });

          _firestore
              .collection('chats')
              .doc(chatId)
              .collection('messages')
              .add({
            'content': messageText,
            'senderId': currentEmail,
            'createdAt': DateTime.now(),
          });

          _textController.clear();
        } else {
          print('No se pudo obtener el correo del otro usuario');
        }
      } else {
        print('No se pudo obtener el usuario actual');
      }
    }
  }

  String _generateChatId(String userEmail1, String userEmail2) {
    List<String> sortedEmails = [userEmail1, userEmail2]..sort();
    return '${sortedEmails[0]}_${sortedEmails[1]}';
  }
}

///

Future<String> _getOtherUserEmail(String userId) async {
  try {
    var userDoc = await FirebaseFirestore.instance
        .collection('Clientes')
        .doc(userId)
        .get();

    // Verificar si se encontró el documento y si contiene el campo 'especialidad'
    if (userDoc.exists && userDoc.data() != null) {
      var userEmail = userDoc.data()!['especialidad'];
      return userEmail.toString(); // Retorna el correo electrónico del usuario
    } else {
      // Manejar el caso en el que no se encuentra el usuario o no tiene 'especialidad'
      return '';
    }
  } catch (e) {
    // Manejar cualquier error que pueda ocurrir durante la obtención de datos
    print('Error al obtener el correo electrónico: $e');
    return '';
  }
}

class ChatMessagesScreen extends StatelessWidget {
  final String currentUserId;
  final String chatId;

  ChatMessagesScreen({required this.currentUserId, required this.chatId});

  final TextEditingController _textController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Messages'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chats')
                  .doc(chatId)
                  .collection('messages')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<DocumentSnapshot> messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    var messageText = message['content'];
                    var senderId = message['senderId'];

                    return ListTile(
                      title: Text(messageText),
                      subtitle: Text('Sender: $senderId'),
                      leading: senderId == currentUserId
                          ? CircleAvatar(child: Text('You'))
                          : null,
                      trailing: senderId != currentUserId
                          ? CircleAvatar(child: Text('Other'))
                          : null,
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Enter your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    String messageText = _textController.text;

    if (messageText.isNotEmpty) {
      // Guarda el mensaje con los IDs de los usuarios en una colección específica del chat
      _firestore.collection('chats').doc(chatId).collection('messages').add({
        'content': messageText,
        'senderId': currentUserId,
        'createdAt': DateTime.now(),
      });

      _textController.clear();
    }
  }
}
