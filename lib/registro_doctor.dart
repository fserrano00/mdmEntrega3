import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RegistroDoctor extends StatelessWidget {
  final firestoreInstance = FirebaseFirestore.instance;

  // Declare controllers for text fields
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _especialidadController = TextEditingController();
  final _direccionController = TextEditingController();
  final _cedulaController = TextEditingController();

  // Declare a ValueNotifier for the doctor certification checkbox
  final ValueNotifier<bool> _isDoctorCertified = ValueNotifier<bool>(false);

  RegistroDoctor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Doctor'),
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
                controller: _especialidadController,
                decoration: InputDecoration(
                  labelText: 'Especialidad',
                ),
              ),
              TextFormField(
                controller: _direccionController,
                decoration: InputDecoration(
                  labelText: 'Dirección del consultorio',
                ),
              ),
              TextFormField(
                controller: _cedulaController,
                decoration: InputDecoration(
                  labelText: 'Cedula profesional',
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
                  Text('Acepto que soy un doctor certificado'),
                ],
              ),
              SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () {
                  // Obtain the values from the form fields
                  final nombre = _nombreController.text;
                  final apellido = _apellidoController.text;
                  final especialidad = _especialidadController.text;
                  final direccion = _direccionController.text;
                  final cedula = _cedulaController.text;
                  final isDoctorCertified = _isDoctorCertified.value;

                  // Add the data to Firestore
                  firestoreInstance.collection("Usuarios2").add({
                    "nombre": nombre,
                    "apellido": apellido,
                    "especialidad": especialidad,
                    "direccion": direccion,
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
