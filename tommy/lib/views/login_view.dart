import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:tommy/constants/routes.dart';
import 'package:tommy/services/auth/auth_service.dart';
import '../utilites/showErrorDialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
      appBar: AppBar(title: Text("Login")),
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
            child: const Text("Login"),
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;

              try {
                await AuthService.firebase()
                    .login(email: email, password: password);
                final user = AuthService.firebase().currentUser;
                if (user?.isEmailVerified ?? false) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesview,
                    (route) => false,
                  );
                } else {
                  AuthService.firebase().sendEmailVerification();
                  Navigator.of(context).pushNamed(verifyEmail);
                }

                // log(UserCredential.toString());
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  await showErrorDialog(
                    context,
                    e.code.toString(),
                  );
                } else if (e.code == 'wrong-password') {
                  await showErrorDialog(
                    context,
                    e.code.toString(),
                  );
                } else {
                  await showErrorDialog(
                    context,
                    e.code.toString(),
                  );
                }
              } catch (e) {
                await showErrorDialog(context, e.toString());
              }
            },
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(register, (route) => false);
              },
              child: const Text("If not registered , then Hit here"))
        ],
      ),
    );
  }
}
