import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_application/auth/login.dart';
import 'package:my_application/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var dbRef = FirebaseDatabase.instance.ref().child('customer');
  var auth = FirebaseAuth.instance;

  Future<void> submit(
      BuildContext context, String email, String password) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    // })
    // await dbRef.push().set(user).then((value) {
    // });

    await auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      Navigator.push(
          context, MaterialPageRoute(builder: ((context) => MyApp())));
      sp.setBool('isLogin', true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Register Pages'),
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => const Login()),
                          ),
                        )
                      },
                      child: Text(
                        'Have an account?',
                        style: TextStyle(color: Colors.blue[900]),
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
                    child: Text("Sign up"),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
