import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynote/views/login_view.dart';
import 'package:mynote/views/register_view.dart';
import 'package:mynote/views/verify_email_view.dart';
import 'dart:developer' as dev show log;

import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
    routes: {
      '/login': (context) => const LoginView(),
      '/register': (context) => const RegisterView()
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text("Home Page"),
    //   ),
    //   body: FutureBuilder(
    //     future: Firebase.initializeApp(
    //       options: DefaultFirebaseOptions.currentPlatform,
    //     ),
    //     builder: (context, snapshot) {
    //       //switch case for loading screen
    //       switch (snapshot.connectionState) {
    //         case ConnectionState.done:
    //           final user = FirebaseAuth.instance.currentUser;
    //
    //           if (user?.emailVerified ?? false) {
    //             return const Text("Done");
    //           } else {
    //             return const LoginView();
    //           }
    //
    //         default:
    //           return const Text("Loading...");
    //       }
    //     },
    //   ),
    // );
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        //switch case for loading screen
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;

            if (user != null) {
              if (user.emailVerified) {
                return const NoteView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

enum MenuAction {
  logout,
}

class NoteView extends StatefulWidget {
  const NoteView({Key? key}) : super(key: key);

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main UI"),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch(value){
                case MenuAction.logout:
                  final out = await showLogOutDialog(context);
                  if(out){
                    //Log the user out
                    await FirebaseAuth.instance.signOut();
                    //Send user to main screen
                    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text("Logout"),
                ),
              ];
            },
          )
        ],
      ),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(context: context, builder: (context) {
    return AlertDialog(title: const Text("Sign out"),
      content: const Text("Are you sure you want to sign out"),
      actions: [
        TextButton(
          onPressed: () {
          Navigator.of(context).pop(false);
        },
            child: const Text("Cancel"),
        ),TextButton(
          onPressed: () {
          Navigator.of(context).pop(true);
        },
            child: const Text("Logout"),
        ),
      ],);
  },).then((value) => value ?? false);
}