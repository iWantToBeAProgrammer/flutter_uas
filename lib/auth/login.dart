import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_application/auth/register.dart';
import 'package:my_application/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_button/sign_in_button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  var db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();

    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  Widget _googleSignInButton() {
    return Center(
      child: SizedBox(
        height: 50,
        child: SignInButton(
          Buttons.google,
          text: 'Sign in with Google',
          onPressed: signInWithGoogle,
        ),
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);

    if (_user != null) {
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setBool('isLogin', true);
      Navigator.push(
          context, MaterialPageRoute(builder: (((context) => MyApp()))));
    }
  }

  void submit(BuildContext context, email, password) async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(
        duration: Duration(seconds: 5),
        content: Text('Email atau password salah'),
        backgroundColor: Colors.red,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    if (_user != null) {
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setBool('isLogin', true);
      Navigator.push(
          context, MaterialPageRoute(builder: (((context) => MyApp()))));
    }

    // QuerySnapshot query =
    //     await db.collection('users').where('email', isEqualTo: email).get();

    // if (query.docs.length > 0) {
    //   if (query.docs[0].get("password") == password) {
    //     sp.setBool('isLogin', true);
    //     // ignore: use_build_context_synchronously
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (((context) => MyApp())),
    //       ),
    //     );
    //   } else {
    //     final snackBar = SnackBar(
    //       duration: Duration(seconds: 5),
    //       content: Text('Password yang dimasukkan salah'),
    //       backgroundColor: Colors.red,
    //     );

    //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //     return;
    //   }
    // } else {
    //   final snackBar = SnackBar(
    //     duration: Duration(seconds: 5),
    //     content: Text('Akun anda belum terdaftar'),
    //     backgroundColor: Colors.red,
    //   );

    //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //   return;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login Pages'),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                    hintText: 'Email', labelText: 'Email'),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          _googleSignInButton(),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: InkWell(
                              onTap: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            const Register())))
                              },
                              child: Text(
                                "Don't Have an account?",
                                style: TextStyle(color: Colors.blue[900]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () => submit(context, emailController.text.toString(),
                    passwordController.text.toString()),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[400]),
                  height: 50,
                  width: double.infinity,
                  child: const Center(
                    child: Text("Sign In"),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
