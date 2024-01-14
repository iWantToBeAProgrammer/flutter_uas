import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_application/auth/login.dart';
import 'package:my_application/auth/register.dart';
import 'package:my_application/auth/update.dart';
import 'package:my_application/models/product.dart';
import 'package:my_application/pages/history_pages.dart';
import 'package:my_application/pages/payment_pages.dart';
import 'package:my_application/pages/product_pages.dart';
import 'package:my_application/pages/shipping_pages.dart';
import 'package:my_application/pages/test_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// ...

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(fontFamily: 'Montserrat'),
      // ignore: prefer_const_constructors
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int total = 0;
  int weight = 0;
  Query dbRef = FirebaseDatabase.instance.ref().child('products');

  List<dynamic> product = [];

  @override
  void initState() {
    super.initState();
    initialization();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  Future<void> _signOut() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    await GoogleSignIn().signOut();
    await _auth.signOut();

    sp.setBool('isLogin', false);

    Navigator.push(context, MaterialPageRoute(builder: ((context) => Login())));
  }

  void initialization() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool? isLogin = sp.getBool('isLogin') ?? false;

    if (!isLogin) {
      await Future.delayed(const Duration(seconds: 2), () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Register()));
      });
    } else if (isLogin) {
      await Future.delayed(const Duration(seconds: 2));
    }
    FlutterNativeSplash.remove();
  }

  Widget listItem(
      {required int index,
      required Map products,
      required DataSnapshot snapshot}) {
    return ListTile(
      leading: SizedBox(
        width: 70,
        height: 100,
        child: Image.network(
          products['image'],
          width: 60,
        ),
      ),
      title: Text(products['name']),
      subtitle: Text(products['price']),
      trailing: ElevatedButton(
        child: Text('Details'),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => ProductPages(products: products)))),
      ),
      onTap: () {
        setState(() {
          total += int.parse(products['price']);
          weight += int.parse(products['weight']);
        });
      },
    );
    // return GridView.builder(
    //   itemCount: 2,s
    //   shrinkWrap: true,
    //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //     crossAxisCount: 2,
    //   ),
    //   itemBuilder: ((context, index) {
    //     return Column(
    //       children: [
    //         Expanded(
    //           child: GestureDetector(
    //             onTap: () {
    //               setState(() {
    //                 total += int.parse(products['price']);
    //               });
    //             },
    //             child: Image.network(
    //               products['image'],
    //               width: 250,
    //               height: 250,
    //               fit: BoxFit.cover,
    //             ),
    //           ),
    //         ),
    //         Padding(
    //           padding: const EdgeInsets.all(5.0),
    //           child: GestureDetector(
    //             onTap: () {
    //               Navigator.push(
    //                 context,
    //                 MaterialPageRoute(
    //                   builder: (context) => ProductPages(
    //                     product: products[index],
    //                   ),
    //                 ),
    //               );
    //             },
    //             child: Text(
    //               products['name'],
    //               style: const TextStyle(
    //                   fontSize: 15, fontWeight: FontWeight.w500),
    //             ),
    //           ),
    //         ),
    //         Padding(
    //           padding: const EdgeInsets.all(5.0),
    //           child: Text(
    //             products['price'].toString(),
    //             style:
    //                 const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
    //           ),
    //         ),
    //       ],
    //     );
    //   }),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.grey[200],
          title: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tani Ratamba UD',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.5,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.black,
                ),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              ),
            )
          ],
        ),
        endDrawer: Drawer(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 50),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                ),
              ),
              const Divider(
                thickness: .8,
                height: 60,
              ),
              GestureDetector(
                onTap: () async {
                  Uri uri = Uri(scheme: 'tel', host: '085967175167');
                  if (!await launchUrl(uri)) {
                    throw Exception("Gagal membuka link!");
                  }
                },
                child: const ListTile(
                  leading: Icon(
                    Icons.phone,
                    color: Colors.green,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  title: Text(
                    'Call Center',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  Uri uri = Uri(scheme: 'sms', host: '085967175167');
                  if (!await launchUrl(uri)) {
                    throw Exception('Gagal Membuka Link!');
                  }
                },
                child: const ListTile(
                  leading: Icon(
                    Icons.message,
                    color: Colors.green,
                  ),
                  title: Text(
                    'SMS Center',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  Uri uri = Uri(
                    scheme: 'geo',
                    path: '-6.982643, 110.409195',
                    query: 'q=Universitas Dian Nuswantoro',
                  );

                  if (!await launchUrl(uri)) {
                    throw Exception('Gagal Membuka Link');
                  }
                },
                child: const ListTile(
                  leading: Icon(
                    Icons.map,
                    color: Colors.green,
                  ),
                  title: Text(
                    'Our Location',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                ),
              ),
              GestureDetector(
                onTap: () => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => HistoryPages())))
                },
                child: const ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Colors.green,
                  ),
                  title: Text(
                    'History',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                ),
              ),
              GestureDetector(
                onTap: () => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => Update())))
                },
                child: const ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Colors.green,
                  ),
                  title: Text(
                    'Update\nUsername Or Password',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                ),
              ),
              GestureDetector(
                onTap: _signOut,
                child: const ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.green,
                  ),
                  title: Text(
                    'Sign Out',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: FirebaseAnimatedList(
            query: dbRef,
            itemBuilder: ((context, snapshot, animation, index) {
              Map products = snapshot.value as Map;

              products['key'] = snapshot.key;

              return listItem(
                  index: index, products: products, snapshot: snapshot);
            }),
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.grey[300],
          width: double.infinity,
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) =>
                            ShippingPages(total: total, weight: weight))),
                  );
                },
                child: Text(
                  'Total: Rp. $total',
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    total = 0;
                  });
                },
                child: const Icon(Icons.delete),
              ),
            ],
          ),
        ));
  }
}
