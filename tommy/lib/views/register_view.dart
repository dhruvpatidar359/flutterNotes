import 'package:flutter/material.dart';

import 'dart:developer';

import 'package:tommy/constants/routes.dart';
import 'package:tommy/services/auth/auth_exceptions.dart';
import 'package:tommy/services/auth/auth_service.dart';

import '../utilites/showErrorDialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    // TODO: implement initState
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
      appBar: AppBar(title: const Text('Regsiter')),
      body: Column(
        children: [
          TextField(
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration:
                const InputDecoration(hintText: "Please enter your email"),
            controller: _email,
          ),
          TextField(
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              controller: _password,
              decoration: const InputDecoration(
                  hintText: "please enter your password")),
          TextButton(
            child: const Text("Register"),
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase()
                    .createUser(email: email, password: password);
                await AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmail);
              } on InvalidEmailAuthException {
                await showErrorDialog(context, "Sahe dal email");
              } on WeakPassowrdAuthException {
                await showErrorDialog(context, "acha password dal");
              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(context, "Email dusra dal");
              } on GenericAuthException{
                await showErrorDialog(context, "failed to register");
              }
            },
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text("Go to Login"))
        ],
      ),
    );
  }
}
