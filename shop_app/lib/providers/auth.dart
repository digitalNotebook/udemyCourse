import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  //este token a cada 1 hora pelo Firebase (mecanismo de segurança)
  // String _token;
  // DateTime expiryDate;
  // String _userId;
  // String _password;

  Future<void> signup(String email, String pass) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDC_K0FNpNzCaL7dKU3TcQZdqG79TjXvEw');
    final response = await http.post(
      url,
      body: json.encode(
        {
          'email': email,
          'password': pass,
          'returnSecureToken': true,
        },
      ),
    );
    print(json.decode(response.body));
  }
}
