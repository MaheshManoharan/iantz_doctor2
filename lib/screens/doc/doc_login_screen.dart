import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firestore_demo/screens/doc/doctor_appointment_screen.dart';

class DocLoginScreen extends StatefulWidget {
  const DocLoginScreen({Key? key}) : super(key: key);

  @override
  _DocLoginScreenState createState() => _DocLoginScreenState();
}

class _DocLoginScreenState extends State<DocLoginScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });

                        if (emailController.text == "" ||
                            passwordController.text == "") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('All fields are required'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
                          QuerySnapshot allresults = await FirebaseFirestore
                              .instance
                              .collection('doctors')
                              .where('username',
                                  isEqualTo: emailController.text)
                              .where('password',
                                  isEqualTo: passwordController.text)
                              .get();

                          if (allresults.docs.isNotEmpty) {
                            final data = allresults.docs.first;
                            final doctorid = data['doctorid'];

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    DoctorAppointmentScreen(doctorid: doctorid),
                              ),
                            );
                          }
                        }
                      },
                      child: Text('login'),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
