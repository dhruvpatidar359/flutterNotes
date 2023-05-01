import 'package:flutter/material.dart';
import 'package:tommy/constants/routes.dart';
import 'package:tommy/services/auth/auth_service.dart';
import '../services/auth/auth_exceptions.dart';
import '../utilites/showErrorDialog.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("verfiy using this")),
      body: Column(children: [
        const Text(
            "If you have not recevied the verification link then , click on the button and get the new verification link"),
        TextButton(
            onPressed: () async {
              final u = AuthService.firebase().currentUser;
              try {
                await AuthService.firebase().sendEmailVerification();
              } on UserNotLoggedInAuthException {
                await showErrorDialog(context, "User is not logged in");
              } on GenericAuthException {
                await showErrorDialog(context, "error has occured");
              }
            },
            child: const Text("Send")),
        TextButton(
          onPressed: () async {
            try {
              await AuthService.firebase().logOut();
            } on UserNotLoggedInAuthException {
              await showErrorDialog(context, "User is not logged in");
            } on GenericAuthException {
              await showErrorDialog(context, "not able to logout");
            }
            Navigator.of(context)
                .pushNamedAndRemoveUntil(register, (route) => false);
          },
          child: const Text(' Restart'),
        )
      ]),
    );
  }
}
