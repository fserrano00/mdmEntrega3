import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

class ChatScreen2 extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

Future<String?> uploadImageToFirebaseStorage(File? imageFile) async {
  if (imageFile == null) {
    return null;
  }

  final storage = FirebaseStorage.instance;
  final Reference storageReference =
      storage.ref().child('images/${DateTime.now().millisecondsSinceEpoch}');

  final UploadTask uploadTask = storageReference.putFile(imageFile);

  await uploadTask.whenComplete(() {});

  String? imageUrl = await storageReference.getDownloadURL();

  return imageUrl;
}

class _ChatScreenState extends State<ChatScreen2> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _messageTextController = TextEditingController();
  File? _imageFile;
  String? selectedRecipient;

  void _getImageFromCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _sendMessage() async {
    final user = _auth.currentUser;
    if (user != null) {
      if (_imageFile != null) {
        String? imageUrl = await uploadImageToFirebaseStorage(_imageFile);

        if (imageUrl != null) {
          await _firestore.collection('messages').add({
            'text': _messageTextController.text,
            'image_url': imageUrl,
            'sender': user.uid,
            'recipient': selectedRecipient,
            'timestamp': FieldValue.serverTimestamp(),
          });

          setState(() {
            _messageTextController.clear();
            _imageFile = null;
          });
        } else {
          // Maneja el caso en el que la carga de la imagen falla.
          print("Error al cargar la imagen en Firebase Storage.");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (recipient) {
              setState(() {});
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'usuario1',
                  child: Text('Usuario 1'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('messages').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final user = _auth.currentUser;

                final messages = snapshot.data!.docs.reversed;
                List<Widget> messageWidgets = [];
                for (var message in messages) {
                  final messageData = message.data() as Map<String, dynamic>?;

                  if (messageData != null) {
                    final messageText = messageData['text'] as String;
                    final messageSender = messageData['sender'] as String;
                    final imageUrl = messageData['image_url'] as String?;
                    final recipient = messageData['recipient'] as String;

                    if (user != null &&
                        (user.uid == messageSender || user.uid == recipient)) {
                      final messageWidget = MessageWidget(
                        text: messageText,
                        sender: messageSender,
                        imageUrl: imageUrl,
                      );

                      messageWidgets.add(messageWidget);
                    }
                  }
                }

                return ListView(
                  reverse: true,
                  children: messageWidgets,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _messageTextController,
                    decoration: InputDecoration(
                      hintText: 'Escribe un mensaje...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.camera),
                  onPressed: () {
                    _getImageFromCamera();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  final String text;
  final String sender;
  final String? imageUrl;

  MessageWidget({required this.text, required this.sender, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          sender,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        if (text.isNotEmpty) Text(text),
        if (imageUrl != null && imageUrl!.isNotEmpty)
          Image.network(
            imageUrl!,
            width: 200,
            height: 200,
          ),
      ],
    );
  }
}
