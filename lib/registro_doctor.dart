import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyectomdm/login.dart';

class RegistroDoctor extends StatelessWidget {
  //TODO CREAR APPEND A FIREBASSE AUTH

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<UserCredential?> _crearCuenta() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _correoElectronico.text,
        password: _contrasenaController.text,
      );
      return userCredential; // Devuelve el userCredential si la creación de cuenta fue exitosa.
    } catch (e) {
      // Ocurrió un error, maneja el error según tus necesidades.
      print("Error: $e");
      return null; // Retorna null si la creación de cuenta falló.
    }
  }

  final firestoreInstance = FirebaseFirestore.instance;

  // Declare controllers for text fields
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _correoElectronico = TextEditingController();
  final _contrasenaController = TextEditingController();
  final _edadController = TextEditingController();
  final _cedulaController = TextEditingController();

  // Declare a ValueNotifier for the doctor certification checkbox
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
                  // Obtain the values from the form fields
                  final nombre = _nombreController.text;
                  final apellido = _apellidoController.text;
                  final correoElectronico = _correoElectronico.text;
                  final contrasena = _contrasenaController.text;
                  final Edad = _edadController.text;
                  final cedula = _cedulaController.text;
                  final isDoctorCertified = _isDoctorCertified.value;

                  // Add the data to Firestore
                  firestoreInstance.collection("Clientes").add({
                    "nombre": nombre,
                    "apellido": apellido,
                    "especialidad": correoElectronico,
                    "contraseña": contrasena,
                    "direccion": Edad,
                    "cedula": cedula,
                    "doctorCertified": isDoctorCertified,
                  }).then((value) {
                    // Show a success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Doctor registrado correctamente.'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }).then((value) {
                    _crearCuenta().then((userCredential) {
                      if (userCredential != null) {
                        // La creación de cuenta fue exitosa, puedes redirigir al usuario a la página deseada.
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) =>
                                LogIn(), // Reemplaza 'OtraPagina' con el nombre de tu página.
                          ),
                        );
                      }
                    });
                  });
                },
                child: Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
