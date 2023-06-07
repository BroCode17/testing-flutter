import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_options.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  //init
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
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          //switch case for loading screen
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    enableSuggestions: false,
                    decoration: const InputDecoration(
                      hintText: "Enter your email",
                    ),
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    autocorrect: false,
                    enableSuggestions: false,
                    decoration: const InputDecoration(
                      hintText: "Enter your password",
                    ),
                  ),
                  TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        try {
                          final userCredentials = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: email, password: password);
                          print(userCredentials);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == "user-not-found")
                            print("User not found");
                          else if (e.code == "wrong-password")
                            print("Incorrect password");
                        }
                      },
                      child: const Text("Login")),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          ('/register'), (route) => false);
                    },
                    child: const Text("Not registered yet? Click here!"),
                  ),
                ],
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
    // return Column(
    //   children: [
    //     TextField(
    //       controller: _email,
    //       keyboardType: TextInputType.emailAddress,
    //       autocorrect: false,
    //       enableSuggestions: false,
    //       decoration: const InputDecoration(
    //         hintText: "Enter your email",
    //       ),
    //     ),
    //     TextField(
    //       controller: _password,
    //       obscureText: true,
    //       autocorrect: false,
    //       enableSuggestions: false,
    //       decoration: const InputDecoration(
    //         hintText: "Enter your password",
    //       ),
    //     ),
    //     TextButton(
    //         onPressed: () async {
    //           final email = _email.text;
    //           final password = _password.text;
    //           try {
    //             final userCredentials = await FirebaseAuth.instance
    //                 .signInWithEmailAndPassword(
    //                 email: email, password: password);
    //             print(userCredentials);
    //           } on FirebaseAuthException catch(e){
    //             if (e.code == "user-not-found")
    //               print("User not found");
    //             else if  (e.code == "wrong-password")
    //               print("Incorrect password");
    //           }
    //
    //         },
    //         child: const Text("Login")
    //     ),
    //     TextButton(
    //         onPressed: (){
    //           Navigator.of(context).pushNamedAndRemoveUntil('/register', (route) => false);
    //         },
    //         child: const Text("Not registered yet? Register here!"))
    //   ],
    // );
  }
}
