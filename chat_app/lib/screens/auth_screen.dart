import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isLoading = false;

  //INSTANCIA GERENCIADA PELO FIREBASE
  final _auth = FirebaseAuth.instance;

  Future<void> _submitAuthForm(
    String user,
    String pass,
    String email,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential authResult;
    try {
      setState(
        () {
          _isLoading = true;
        },
      );
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: pass,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: pass);

        //armazenamos a informação no firestore e exibimos um loading spinner
        FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set(
          {
            'username': user,
            'email': email,
          },
        );
      }
    } on PlatformException catch (error) {
      var message = "An error ocurred, please check your credentials";

      if (error.message != null) {
        message = error.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(
        () {
          _isLoading = false;
        },
      );
    } catch (err) {
      print(err);
      setState(
        () {
          _isLoading = false;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
