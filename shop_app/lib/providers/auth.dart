import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  //este token a cada 1 hora pelo Firebase (mecanismo de segurança)

  String _token = '';
  DateTime? _expiryDate;
  late String _userId;
  String? _password;
  //Vamos gerenciar o timer, para cancelar timers existentes
  Timer? _authTimer;

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
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDC_K0FNpNzCaL7dKU3TcQZdqG79TjXvEw');
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
      _autoLogout();
      //Atualiza o main.dart
      notifyListeners();
      //obtemos uma instância para gravar o key:value na memória do dispositivo
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate!.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
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

  Future<bool> tryAutoLogin() async {
    print('tryAutoLogin');
    final prefs = await SharedPreferences.getInstance();
    //verificamos se essa chave existe na memória persistente
    if (!prefs.containsKey('userData')) {
      return false;
    }
    print('contains key userData');
    // print(prefs.getString('userData'));
    //caso passemos pelo primeiro check, obtemos as informações gravadas
    final extractedUserData = json.decode(prefs.getString('userData') as String)
        as Map<String, dynamic>;
    // print(extractedUserData);
    //capturamos a informação da Date para definir se o token ainda é valido
    final expiryDate =
        DateTime.parse((extractedUserData['expiryDate']) as String);
    // print(extractedUserData['expiryDate']);
    //testamos se o data de expiração é anterior a atual
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    //caso esteja tudo ok, setamos os campos
    //resetamos o timer do autologout
    //avisamos todos com o notifyListeners()
    _token = extractedUserData['token'] as String;
    _userId = extractedUserData['userId'] as String;
    _expiryDate = expiryDate;
    print('$_token, $_userId, $_expiryDate');
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    print('logout');
    _token = '';
    _userId = '';
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    //podemos usar o remove para tirar varios dados do SharedPreferences, mas não todos
    // prefs.remove('userData');
    //ele tirar todos os dados da SharedPreferences
    prefs.clear();
  }

  //setamos um timer que irá expirar quando o token expirar
  void _autoLogout() {
    //Precisamos gerenciar esse timer para caso já tenhamos um, possamos cancela-lo
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    //proveniente do dart:async
    print('autoLogout');
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
