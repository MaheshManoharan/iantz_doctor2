import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firestore_demo/screens/user_booking_history.dart';
import 'package:flutter_firestore_demo/services/auth_service.dart';

import 'calendar_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<List<QueryDocumentSnapshot<Object?>>> getDoctors() async {
    QuerySnapshot qn = await firestore.collection('doctors').get();
    return qn.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        backgroundColor: Colors.pink,
        actions: [
          TextButton.icon(
            onPressed: () async {
              await AuthService().signOut();
            },
            icon: const Icon(
              Icons.logout,
            ),
            label: const Text(
              'Sign out',
            ),
            style: TextButton.styleFrom(
              primary: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          ElevatedButton(
            child: Text('Booking History'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UserBookingHistory(),
                ),
              );
            },
          ),
          Row(
            children: [
              const Text('Doctor 1'),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CalendarScreen(
                        doctorid: 'doctor_1',
                      ),
                    ),
                  );
                },
                child: const Text('Make AppointMent'),
              ),
            ],
          ),
          Row(
            children: [
              const Text('Doctor 2'),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CalendarScreen(
                        doctorid: 'doctor_2',
                      ),
                    ),
                  );
                },
                child: const Text('Make AppointMent'),
              ),
            ],
          ),
          Row(
            children: [
              const Text('Doctor 3'),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          const CalendarScreen(doctorid: 'doctor_3'),
                    ),
                  );
                },
                child: const Text('Make AppointMent'),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () 
            {
              
            },
            child: const Text('Are you a doctor?'),
          ),
        ],
      ),
    );
  }
}
// Container(
//         width: MediaQuery.of(context).size.width,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               child: Text('Add data to Firestore'),
//               onPressed: () async {
//                 User? user = auth.currentUser;

//                 CollectionReference users = firestore.collection('users');
//                 await users.add({'name': "Rahul"});
//               },
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 CollectionReference users = firestore.collection('users');
//                 QuerySnapshot allResults = await users.get();
//               },
//               child: Text('Read Data From Firestore'),
//             ),
//           ],
//         ),
//       ),
