import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  final String doctorid;

  const CalendarScreen({Key? key, required this.doctorid}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  bool loading = false;

  DateTime? appointmentDate;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TableCalendar(
            onDaySelected: (selecctDay, focussedDay) {
              setState(() {
                selectedDay = selecctDay;
                appointmentDate = selecctDay;
                //  finalAppointment = selecctDay;
                focusedDay = focussedDay;
              });
              print(selecctDay);
            },
            firstDay: DateTime(2021),
            focusedDay: selectedDay,
            lastDay: DateTime(2050),
            selectedDayPredicate: (DateTime date) {
              return isSameDay(selectedDay, date);
            },
            startingDayOfWeek: StartingDayOfWeek.sunday,
            calendarStyle: const CalendarStyle(
              isTodayHighlighted: true,
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
          ),
          Text('Appointment day: $selectedDay'),
          Text('${widget.doctorid}'),
          loading
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    CollectionReference appointment =
                        firestore.collection('appointments');

                    if (appointmentDate == null) {
                      setState(() {
                        loading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'You should tap the date which you want to book'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      QuerySnapshot allresults = await FirebaseFirestore
                          .instance
                          .collection('appointments')
                          .where('day', isEqualTo: selectedDay)
                          .where('doctorid', isEqualTo: widget.doctorid)
                          .get();

                      if (allresults.docs.isEmpty) {
                        User? user = firebaseAuth.currentUser;
                        String userid = user!.uid;

                        await appointment.add({
                          'userid': userid,
                          'day': selectedDay,
                          'doctorid': widget.doctorid,
                          'name': user.email,
                        }).then((value) {
                          setState(() {
                            loading = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('appointment set'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        });
                      }

                      if (allresults.docs.isNotEmpty) {
                        setState(() {
                          loading = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Already someone appointed'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }

                    // });
                  },
                  child: const Text('set appointment'),
                )
        ],
      ),
    );
  }
}












// class CalendarScreen extends StatefulWidget {
//   final String doctorid;

//   const CalendarScreen({Key? key, required this.doctorid}) : super(key: key);

//   @override
//   _CalendarScreenState createState() => _CalendarScreenState();
// }

// class _CalendarScreenState extends State<CalendarScreen> {
//   late CalendarController _controller;

//   @override
//   void initState() {
//     super.initState();

//     _controller = CalendarController();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: SingleChildScrollView(
//       child: Column(
//         children: [
//           TableCalendar(
//             firstDay: ,
//             initialCalendarFormat: CalendarFormat.month,
//             startingDayOfWeek: StartingDayOfWeek.sunday,
//             startDay: DateTime.now(),
//             onDaySelected: (datetime, __, ___) {
//               print(datetime);
//               print(widget.doctorid);
//             },
//             calendarController: _controller,
//           ),
//         ],
//       ),
//     ));
//   }
// }
