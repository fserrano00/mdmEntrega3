import 'package:flutter/material.dart';
import 'package:proyectomdm/menu_lateral.dart';
import 'package:table_calendar/table_calendar.dart';
import 'firebase_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isDrawerOpen = false;

  void toggleDrawer() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MediManager"),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: toggleDrawer,
        ),
      ),
      drawer: SidebarMenu(),
      body: SafeArea(
        child: SingleChildScrollView(
          // Envuelve todo el contenido con SingleChildScrollView
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20, top: 20),
                child: Row(
                  children: [
                    Text(
                      "Gusto de verte ",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade900),
                    ),
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
                padding: const EdgeInsets.all(8.0),
                child: TableCalendar(
                    focusedDay: DateTime.now(),
                    firstDay: DateTime.utc(2010, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14)),
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
