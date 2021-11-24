import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  //INSTANCIA GERENCIADA PELO FIREBASE
  final _auth = FirebaseAuth.instance;

  void _submitAuthForm(
    String user,
    String pass,
    String email,
    bool isLogin,
  ) {
    if (isLogin) {
      _auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
    } else {
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm),
    );
  }
}
