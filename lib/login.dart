import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyectomdm/bloc/manager_bloc.dart';
import 'package:proyectomdm/crear_Cuenta.dart';
import 'package:proyectomdm/main_page.dart';
import 'package:proyectomdm/registro_doctor.dart';

class LogIn extends StatelessWidget {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(children: [
          Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/medimanagerlogo.jpeg",
                    width: 120,
                    height: 120,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Text(
                      "MediManager",
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Text(
                      "Bienvenido a MediManager",
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Text(
                      "Inicia Sesión para continuar",
                      style: TextStyle(color: Colors.indigo, fontSize: 15),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _emailController,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: "Correo Electrónico",
                    labelStyle: TextStyle(color: Colors.deepPurple),
                    hintText: 'Ingresa tu correo electrónico',
                    prefixIcon: Icon(
                      Icons.mail,
                      color: Colors.deepPurple,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    labelStyle: TextStyle(color: Colors.deepPurple),
                    hintText: 'Ingresa tu contraseña',
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.deepPurple,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              SizedBox(
                width: 350,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<ManagerBloc>(context).add(
                      LoginEvent(
                        email: _emailController.text,
                        password: _passwordController.text,
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blue.shade900),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                  ),
                  child: Text(
                    "Iniciar Sesión",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RegistroDoctor(), // Replace RegisterPage with the desired page
                          ),
                        );
                      },
                      child:
                          Text("¿No tienes una cuenta aún? Regístrate Ahora"),
                    ),
                  ],
                ),
              ),
              BlocListener<ManagerBloc, ManagerState>(
                listener: (context, state) {
                  if (state is SuccessState) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainPage(),
                      ),
                    );
                  }
                },
                child: Container(),
              )
            ],
          ),
        ]),
      ),
    );
  }
}
