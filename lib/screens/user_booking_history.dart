import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserBookingHistory extends StatelessWidget {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // <1> Use StreamBuilder
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          // <2> Pass `Stream<QuerySnapshot>` to stream
          stream: FirebaseFirestore.instance
              .collection('appointments')
              .where(
                'userid',
                isEqualTo: firebaseAuth.currentUser!.uid,
              )
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('no bookings'),
              );
            }

            if (snapshot.hasData) {
              // <3> Retrieve `List<DocumentSnapshot>` from snapshot
              final List<DocumentSnapshot> documents = snapshot.data!.docs;
              return ListView(
                children: documents.map((doc) {
                  Timestamp t = doc['day'];
                  DateTime d = t.toDate();

                  //var date = DateTime.fromMicrosecondsSinceEpoch(doc['day'].toDate().toString());
                  return Card(
                    child: Column(
                      children: [
                        Text(doc['userid']),
                        Text(doc['doctorid']),
                        Text(doc['name']),
                        Text(d.toString()),
                        // Text(
                        //     '${DateTime.fromMicrosecondsSinceEpoch(doc['day'])}'),
                      ],

                      //leading: Text(doc['day']),
                    ),
                  );
                }).toList(),
              );
            } else if (snapshot.hasError) {
              return Text('Itgone');
            } else {
              return Text('something happened');
            }
          }),
    );
  }
}
