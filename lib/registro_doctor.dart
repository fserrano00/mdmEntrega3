import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyectomdm/login.dart';

class RegistroDoctor extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final firestoreInstance = FirebaseFirestore.instance;

  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _correoElectronico = TextEditingController();
  final _contrasenaController = TextEditingController();
  final _edadController = TextEditingController();
  final _cedulaController = TextEditingController();

  final ValueNotifier<bool> _isDoctorCertified = ValueNotifier<bool>(false);

  RegistroDoctor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro MediManager'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                ),
              ),
              TextFormField(
                controller: _apellidoController,
                decoration: InputDecoration(
                  labelText: 'Apellido',
                ),
              ),
              TextFormField(
                controller: _correoElectronico,
                decoration: InputDecoration(
                  labelText: 'Correo electronico',
                ),
              ),
              TextFormField(
                controller: _contrasenaController,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                ),
              ),
              TextFormField(
                controller: _edadController,
                decoration: InputDecoration(
                  labelText: 'Edad',
                ),
              ),
              TextFormField(
                controller: _cedulaController,
                decoration: InputDecoration(
                  labelText: 'Cedula profesional (en caso de tener)',
                ),
              ),
              Row(
                children: <Widget>[
                  ValueListenableBuilder<bool>(
                    valueListenable: _isDoctorCertified,
                    builder: (context, isCertified, child) {
                      return Checkbox(
                        value: isCertified,
                        onChanged: (value) {
                          _isDoctorCertified.value = value ?? false;
                        },
                      );
                    },
                  ),
                  Text('Soy doctor '),
                ],
              ),
              SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () {
                  final nombre = _nombreController.text;
                  final apellido = _apellidoController.text;
                  final correoElectronico = _correoElectronico.text;
                  final contrasena = _contrasenaController.text;
                  final Edad = _edadController.text;
                  final cedula = _cedulaController.text;
                  final isDoctorCertified = _isDoctorCertified.value;

                  _crearCuenta(
                    nombre,
                    apellido,
                    correoElectronico,
                    contrasena,
                    Edad,
                    cedula,
                    isDoctorCertified,
                    context,
                  );
                },
                child: Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _crearCuenta(
    String nombre,
    String apellido,
    String correoElectronico,
    String contrasena,
    String Edad,
    String cedula,
    bool isDoctorCertified,
    BuildContext context,
  ) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: correoElectronico,
        password: contrasena,
      );

      String uid = userCredential.user!.uid;

      await firestoreInstance.collection('Clientes').doc(uid).set({
        "nombre": nombre,
        "apellido": apellido,
        "correo": correoElectronico,
        "contraseña": contrasena,
        "direccion": Edad,
        "cedula": cedula,
        "doctorCertified": isDoctorCertified,
        "uid": uid,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Doctor registrado correctamente.'),
          backgroundColor: Colors.green,
        ),
      );

      _navigateToLoginScreen(context);
    } catch (e) {
      print("Error: $e");
    }
  }

  void _navigateToLoginScreen(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LogIn(),
      ),
    );
  }
}
