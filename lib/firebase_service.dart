import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getUsuarios() async {
  List Usuarios = [];
  CollectionReference collectionReferenceUsuarios = db.collection('Usuarios');

  QuerySnapshot queryUsuarios = await collectionReferenceUsuarios.get();

  queryUsuarios.docs.forEach((documento) {
    Usuarios.add(documento.data());
  });

  return Usuarios;
}

Future<void> sendUsuarios(String nombre, String correo, String telefono) async {
  CollectionReference collectionReferenceUsuarios = db.collection('Usuarios');

  await collectionReferenceUsuarios.add({
    'nombre': nombre,
    'correo': correo,
    'telefono': telefono,
  });
}
