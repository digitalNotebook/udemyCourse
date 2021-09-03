import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  //este token a cada 1 hora pelo Firebase (mecanismo de segurança)

  String _token = '';
  DateTime? _expiryDate;
  late String _userId;
  late String _password;

  //checamos se o token está vazio, se sim o usuário não está autenticado
  bool get isAuth {
    return token != '';
  }

  String get token {
    if (_expiryDate != null) {
      if (_expiryDate!.isAfter(DateTime.now())) {
        if (_token != null) {
          return _token;
        }
      }
    }
    return '';
  }

  String get userId {
    //talvez fazer checagens antes de retornar
    return _userId;
  }

  Future<void> _authenticate(
      String email, String pass, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=[API_KEY]');
    try {
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
      //podem existir erros no body emitidos pelo Firebase
      //por isso precisamos checar
      var responseData = json.decode(response.body);
      //imprimimos a mensagem de erro para descobrir

      if (responseData['error'] != null) {
        //mesmo com uma requisição retornando 200, temos um erro
        //apenas fazemos o rethrow do error
        //para exibir mensagens para o usuário
        throw HttpException(
          responseData['error']['message'],
        );
      }
      //se passarmos por toda a validação, setamos o token
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      //pegamos a data atual e adicionamos os segundos, após a conversão
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      //Atualiza o main.dart
      notifyListeners();
    } catch (error) {
      //apenas fazemos o rethrow do error
      //para exibir mensagens para o usuário
      throw error;
    }
  }

  Future<void> signup(String email, String pass) async {
    //usamos o return senão não veremos o circularProgressIndicator
    //sem o return não vamos esperar o authenticate fazer o seu job
    return _authenticate(email, pass, 'signUp');
  }

  Future<void> signin(String email, String pass) async {
    //usamos o return senão não veremos o circularProgressIndicator
    //sem o return não vamos esperar o authenticate fazer o seu job
    return _authenticate(email, pass, 'signInWithPassword');
  }
}
