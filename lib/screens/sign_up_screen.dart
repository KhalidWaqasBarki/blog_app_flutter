import 'package:blog_app/components/round_button.dart';
import 'package:blog_app/components/text_component.dart';
import 'package:blog_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../utils/Utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool showspinner = false;
  final auth = FirebaseAuth.instance;
  final emailCon = TextEditingController();
  final passwordCon = TextEditingController();
  final formkey = GlobalKey<FormState>();
  String? email, password;

  void signUp()async{
    showspinner = true;
    setState(() {});
    try {

          await auth.createUserWithEmailAndPassword(
          email: emailCon.text.toString(),
          password: passwordCon.text.toString()).then((value){
        showspinner = false;
        setState(() {});
        Utils().toastmessage('User created successfully');
        Navigator.push(context, MaterialPageRoute(builder: (_)=> LoginScreen()));
      });

    }

    catch (e) {
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

          automaticallyImplyLeading: false,
          title: Textt(text: 'Sign Up', fontsize: 25),
          backgroundColor: Colors.cyan,

          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Textt(text: 'Register Here', fontsize: 32),
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
                    title: 'Register',
                    onpress: () async {
                      if (formkey.currentState!.validate()) {
                       signUp();
                      }
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => LoginScreen()));
                        },
                        child: Text(
                          'Sign in',
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

