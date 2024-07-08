import 'package:blog_app/components/round_button.dart';
import 'package:blog_app/utils/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final forgotCon = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool showSpinner = false;
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: forgotCon,
                  decoration: InputDecoration(
                  filled: true,
                      fillColor: Colors.grey[50],
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      hintText: 'Enter Your Email'),
                  validator: (value) {
                    return value!.isEmpty ? 'enter email' : null;
                  },
                ),
                SizedBox(height: 30),
                RoundButton(
                    title: 'Send',
                    onpress: () {
                      if(formkey.currentState!.validate()){
                        showSpinner = true;
                        setState(() {});

                        auth
                            .sendPasswordResetEmail(
                            email: forgotCon.text.toString())
                            .then((val) {
                          showSpinner =false;
                          setState(() {});
                          Utils().toastmessage('Please check your email');
                        }).onError((error, stackTrace) {
                          showSpinner = false;
                          setState(() {});

                          Utils().toastmessage(error.toString());
                        });
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
