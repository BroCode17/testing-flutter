import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mynote/constants/routes.dart';
import 'package:mynote/util/show_error_dialog.dart';
import 'dart:developer' as dev show log;

import '../firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
              // TODO: Handle this case.
                return Column(
                  children: [
                    TextField(
                      controller: _email,
                      autocorrect: false,
                      enableSuggestions: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "Enter your email",
                      ),
                    ),
                    TextField(
                      controller: _password,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        hintText: "Enter your password",
                      ),
                    ),
                    TextButton(onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;
                      try {
                        final userCredential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                            email: email, password: password);
                        final currentUser = FirebaseAuth.instance.currentUser;
                        currentUser?.sendEmailVerification();
                        Navigator.of(context).pushNamed(verifyEmailRoute);
                      } on FirebaseAuthException catch (e) {
                        //Todo: code
                        dev.log(e.code);
                        if (e.code == 'weak-password') {
                          await showErrorDialog(context, "Weak Password");
                        } else if (e.code == 'email-already-in-use') {
                          await showErrorDialog(
                              context, "Email is already in use");
                        } else if (e.code == 'invalid-email') {
                          await showErrorDialog(context, "Invalid email");
                        } else if (e.code == 'invalid-password') {
                          await showErrorDialog(
                              context, "Enter a valid password");
                        } else {
                          await showErrorDialog(context, "Error: ${e.code}");
                        }
                      } catch (e) {
                        await showErrorDialog(
                            context, "Error: ${e.toString()}");
                      }
                    }, child: const Text("Register")),
                    TextButton(onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          loginRoute, (route) => false);
                    }, child: const Text("Already registered? Login here!")),
                  ],
                );
              default:
                return const Text("Loading...");
            }
          }
      ),
    );
    return Column(
      children: [
        TextField(
          controller: _email,
          autocorrect: false,
          enableSuggestions: false,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: "Enter your email",
          ),
        ),
        TextField(
          controller: _password,
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          decoration: const InputDecoration(
            hintText: "Enter your password",
          ),
        ),
        TextButton(onPressed: () async {
          final email = _email.text;
          final password = _password.text;
          try {
            final userCredential = await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                email: email, password: password);
          } on FirebaseAuthException catch (e) {
            //Todo: code
            print(e.code);
            if (e.code == 'weak-password')
              print("Weak Password");
            else if (e.code == 'email-already-in-use')
              print("Email is already in use");
            else if (e.code == 'invalid-email')
              print("Invalid email");
          }
        }, child: const Text("Register")),
      ],
    );
  }
}