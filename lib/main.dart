import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyectomdm/bloc/manager_bloc.dart';
import 'package:proyectomdm/crear_Cuenta.dart';
import 'package:proyectomdm/firebase_options.dart';
import 'package:proyectomdm/login.dart';
import 'package:proyectomdm/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(BlocProvider(
    create: (context) => ManagerBloc(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: LogIn(),
    );
  }
}
