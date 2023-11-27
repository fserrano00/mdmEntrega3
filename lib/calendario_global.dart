import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Event {
  final String title;
  final DateTime date;

  Event({
    required this.title,
    required this.date,
  });
}

class CalendarioCitas extends StatefulWidget {
  const CalendarioCitas({Key? key}) : super(key: key);

  @override
  State<CalendarioCitas> createState() => _CalendarioCitasState();
}

class _CalendarioCitasState extends State<CalendarioCitas> {
  DateTime today = DateTime.now();
  TextEditingController _eventController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendario de Citas"),
      ),
      body: Stack(
        children: [
          ContentWidget(
            user: user,
            today: today,
            eventController: _eventController,
            onDaySelected: _onDaySelected,
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      scrollable: true,
                      title: Text("Motivo cita "),
                      content: Padding(
                        padding: EdgeInsets.all(8),
                        child: TextField(
                          controller: _eventController,
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            _saveEventToFirestore();
                            Navigator.of(context).pop();
                          },
                          child: Text("Guardar"),
                        )
                      ],
                    );
                  },
                );
              },
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  void _saveEventToFirestore() async {
    final firestore = FirebaseFirestore.instance;
    final selectedDay = today;

    if (user != null) {
      final event = {
        'title': _eventController.text,
        'date': selectedDay,
      };

      await firestore
          .collection('Citas2')
          .doc(user?.uid)
          .collection('Detalles')
          .add(event);
    }

    setState(() {
      _eventController.clear();
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      today = selectedDay;
    });
  }
}

class ContentWidget extends StatelessWidget {
  final User? user;
  final DateTime today;
  final TextEditingController eventController;
  final Function(DateTime, DateTime) onDaySelected;

  const ContentWidget({
    Key? key,
    required this.user,
    required this.today,
    required this.eventController,
    required this.onDaySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Citas2')
          .doc(user?.uid)
          .collection('Detalles')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData) {
          return Text('No hay datos disponibles');
        }

        final querySnapshot = snapshot.data as QuerySnapshot;
        final events = querySnapshot.docs
            .map((doc) => Event(
                  title: doc['title'],
                  date: (doc['date'] as Timestamp).toDate(),
                ))
            .toList();

        return Column(
          children: [
            TableCalendar(
              focusedDay: today,
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              selectedDayPredicate: (day) => isSameDay(day, today),
              onDaySelected: onDaySelected,
              eventLoader: (day) {
                return events
                    .where((event) => isSameDay(event.date, day))
                    .toList();
              },
            ),
            if (events.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  color: Colors.blue,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Eventos para el día seleccionado:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        for (var event in events)
                          ListTile(
                            title: Text(
                              event.title,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
