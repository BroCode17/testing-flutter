
import 'package:flutter/material.dart';
import 'package:mynote/constants/routes.dart';
import 'package:mynote/services/auth/auth_service.dart';
import 'package:mynote/util/show_error_dialog.dart';
import 'dart:developer' as dev show log;

import '../firebase_options.dart';
import '../services/auth/auth_exceptions.dart';

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
          future: AuthService.firebase().initialize(),
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
                        await AuthService.firebase().createUser(email: email, password: password);
                        final currentUser = AuthService.firebase().currentUser;
                        AuthService.firebase().sendEmailVerification();
                        Navigator.of(context).pushNamed(verifyEmailRoute);
                      } on WeakPasswordAuthException{
                        await showErrorDialog(context, "Weak Password");
                      } on EmailAlreadyAuthException{
                        await showErrorDialog(
                            context, "Email is already in use");
                      } on InvalidEmailAuthException{
                        await showErrorDialog(
                            context, "Enter a valid password");
                      } on GenericAuthException{
                        await showErrorDialog(context, "Field to register");
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

  }
}