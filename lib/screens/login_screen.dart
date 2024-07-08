import 'package:blog_app/components/round_button.dart';
import 'package:blog_app/components/text_component.dart';
import 'package:blog_app/screens/blogs.dart';
import 'package:blog_app/screens/forgot_screen.dart';
import 'package:blog_app/screens/sign_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../utils/Utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showspinner = false;
  final auth = FirebaseAuth.instance;
  final emailCon = TextEditingController();
  final passwordCon = TextEditingController();
  final formkey = GlobalKey<FormState>();
  String? email, password;

  void login() async {
    showspinner = true;
    setState(() {});
    try {
      await auth.signInWithEmailAndPassword(
          email: email.toString(), password: password.toString());
      showspinner = false;
      setState(() {});
      Utils().toastmessage('User logged in');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomeScreen()));
    } catch (e) {
      showspinner = false;
      setState(() {});
      Utils().toastmessage(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showspinner,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          title: Textt(text: 'Login', fontsize: 25),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Textt(text: 'Login Here', fontsize: 32),
                SizedBox(height: 30),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailCon,
                  decoration: InputDecoration(
                      fillColor: Colors.grey[100],
                      filled: true,
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      hintText: 'email'),
                  onChanged: (value) {
                    email = value;
                  },
                  validator: (value) {
                    return value!.isEmpty ? 'enter email' : null;
                  },
                ),
                SizedBox(height: 30),
                TextFormField(
                  obscureText: true,
                  controller: passwordCon,
                  decoration: InputDecoration(
                      fillColor: Colors.grey[100],
                      filled: true,
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      hintText: 'password'),
                  onChanged: (value) {
                    password = value;
                  },
                  validator: (value) {
                    return value!.isEmpty ? 'enter password' : null;
                  },
                ),
                SizedBox(height: 30),
                RoundButton(
                    title: 'Login',
                    onpress: () async {
                      if (formkey.currentState!.validate()) {
                        login();
                      }
                    }),
                SizedBox(
                  height: 12,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => ForgotScreen()));
                      },
                      child: const Text(
                        'Forgot Password ? ',
                        style: TextStyle(color: Colors.indigo),
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => SignUpScreen()));
                        },
                        child: Text(
                          'Register Here',
                          style: TextStyle(color: Colors.indigo),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
