import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyectomdm/bloc/manager_bloc.dart';

import 'package:proyectomdm/menu_lateral.dart';
import 'package:table_calendar/table_calendar.dart';
import 'firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proyectomdm/calendario_global.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

bool isDrawerOpen = false;

class _MainPageState extends State<MainPage> {
  DateTime today = DateTime.now();
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      today = selectedDay;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    User? getCurrentUser() {
      return FirebaseAuth.instance.currentUser;
    }

    User? user = getCurrentUser();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("MediManager"),
        leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            }),
      ),
      drawer: SidebarMenu(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20, top: 20),
                child: Row(
                  children: <Widget>[
                    if (user != null)
                      Text(
                        'Hola ${user.email}',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple.shade900),
                      ),
                    if (user == null) Text('No hay usuario'),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  top: 20,
                ),
                child: Row(
                  children: [
                    Text(
                      "Estas son tus siguientes citas",
                      style: TextStyle(
                          color: Colors.indigo,
                          decoration: TextDecoration.underline,
                          fontSize: 14),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: ContentWidget(
                  user: getCurrentUser(),
                  today: DateTime.now(),
                  eventController: TextEditingController(),
                  onDaySelected: _onDaySelected,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  top: 20,
                ),
                child: Row(
                  children: [
                    Text(
                      "Resumen(es) de tus últimas citas",
                      style: TextStyle(
                          color: Colors.indigo,
                          decoration: TextDecoration.underline,
                          fontSize: 14),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue.shade900,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0)),
                  child: ListTile(
                    leading: Icon(Icons.arrow_forward_ios_sharp),
                    title: Text("Consulta Dra Marta - 20/10/2023"),
                    onTap: () {},
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue.shade900,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0)),
                  child: ListTile(
                    leading: Icon(Icons.arrow_forward_ios_sharp),
                    title: Text("Consulta Dra Marta - 20/10/2023"),
                    onTap: () {},
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue.shade900,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0)),
                  child: ListTile(
                    leading: Icon(Icons.arrow_forward_ios_sharp),
                    title: Text("Consulta Dra Marta - 20/10/2023"),
                    onTap: () {},
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  top: 20,
                ),
                child: Row(
                  children: [
                    Text(
                      "Tus doctore Asignade",
                      style: TextStyle(
                          color: Colors.indigo,
                          decoration: TextDecoration.underline,
                          fontSize: 14),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
