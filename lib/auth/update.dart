import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Update extends StatefulWidget {
  const Update({super.key});

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    emailController.text = sp.getString('email').toString();
    passwordController.text = sp.getString('password').toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Account'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 100),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Email',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
            ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(prefixIcon: Icon(Icons.email)),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Password',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
            ),
            TextFormField(
              controller: passwordController,
              decoration:
                  const InputDecoration(prefixIcon: Icon(Icons.password)),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () async {
                SharedPreferences sp = await SharedPreferences.getInstance();

                sp.setString('email', emailController.text.toString());
                sp.setString('password', passwordController.text.toString());

                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.green[900],
                ),
                width: 100,
                height: 40,
                child: const Center(
                  child: Text(
                    'Update',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
