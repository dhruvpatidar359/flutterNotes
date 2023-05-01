import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:tommy/constants/routes.dart';
import 'package:tommy/services/auth/auth_exceptions.dart';
import 'package:tommy/services/auth/auth_service.dart';
import 'package:tommy/services/crud/note_service.dart';
import 'package:tommy/utilites/showErrorDialog.dart';
import '../../enums/menu_action.dart';
import '../../main.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email!;
  @override
  void initState() {
    // TODO: implement initState
    _notesService = NotesService();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _notesService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Notes"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(newNoteRoute);
              },
              icon: Icon(Icons.add)),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              log(value.name);
              switch (value) {
                case MenuAction.logout:
                  // TODO: Handle thisdf case.
                  final shoudlLogout = await showLogOutDialog(context);
                  if (shoudlLogout) {
                    try {
                      await AuthService.firebase().logOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/login/',
                        (route) => false,
                      );
                    } on UserNotLoggedInAuthException {
                      await showErrorDialog(context, "User is not logged in");
                    } on GenericAuthException {
                      await showErrorDialog(context, "not able to logout");
                    }
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                    value: MenuAction.logout, child: Text('Log Out')),
              ];
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                  stream: _notesService.allNotes,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        // TODO: Handle this case.
                        return const Text("we are waiting for the notes");
                      default:
                        return const CircularProgressIndicator();
                    }
                  });
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
