import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class HistoryPages extends StatefulWidget {
  const HistoryPages({super.key});

  @override
  State<HistoryPages> createState() => _HistoryPagesState();
}

class _HistoryPagesState extends State<HistoryPages> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  Query dbRef = FirebaseDatabase.instance.ref();

  Widget listItem(
      {required int index,
      required Map orders,
      required DataSnapshot snapshot}) {
    int id = index + 1;
    return ListTile(
      // ignore: prefer_interpolation_to_compose_strings

      leading: Text(id.toString()),
      title: Text(
        "total pesanan terbayar: " + orders['price'],
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      ),
      trailing: SizedBox(
        width: 80,
        child: Icon(
          Icons.verified_rounded,
          color: Colors.green,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History Pages'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: FirebaseAnimatedList(
          query: dbRef.ref.child('order/$uid'),
          itemBuilder: ((context, snapshot, animation, index) {
            Map orders = snapshot.value as Map;

            orders['key'] = snapshot.key;

            return listItem(index: index, orders: orders, snapshot: snapshot);
          }),
        ),
      ),
    );
  }
}
