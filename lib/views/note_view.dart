import 'package:flutter/material.dart';
import 'package:mynote/services/auth/auth_service.dart';

import '../constants/routes.dart';
import '../enums/menu_action.dart';

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
                    await AuthService.firebase().logOut();
                    //Send user to main screen
                    Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
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