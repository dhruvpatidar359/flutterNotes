import 'package:flutter/material.dart';
import 'package:tommy/constants/routes.dart';
import 'package:tommy/services/auth/auth_service.dart';
import 'package:tommy/views/login_view.dart';
import 'package:tommy/views/notes/new_note_view.dart';
import 'package:tommy/views/notes/notes_view.dart';
import 'package:tommy/views/register_view.dart';


import 'dart:developer';

import 'views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized;
  runApp(
    MaterialApp(
      title: "Flutter Demo",
      theme: ThemeData(primaryColor: Colors.blue),
      home: const Home(),
      routes: {
        loginRoute: (context) => const LoginView(),
        register: (context) => const RegisterView(),
        notesview: (context) => const NotesView(),
        verifyEmail: (context) => const VerifyEmail(),
        newNoteRoute: (context) => const NewNotesView(),
      },
    ),
  );
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            log("$user");
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmail();
              }
            } else {
              return const LoginView();
            }

          default:
            return const Text('Loading ...');
        }
      },
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Sign Out"),
          content: const Text('Are you sure want to sign out'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("Cancel")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text("Proceed"))
          ],
        );
      }).then((value) => value ?? false);
}
