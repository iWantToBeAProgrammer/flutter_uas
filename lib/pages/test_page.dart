import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  var db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: FloatingActionButton(
              onPressed: () {
                final user = <String, dynamic>{
                  "first": "Ada",
                  "last": "Lovelace",
                  "born": 1815
                };

// Add a new document with a generated ID
                db.collection("users").add(user).then((DocumentReference doc) =>
                    print('DocumentSnapshot added with ID: ${doc.id}'));
              },
              child: Icon(Icons.add),
            ),
          )
        ],
      ),
    );
  }
}
