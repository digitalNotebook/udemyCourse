import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  var _isLogin = true;

  var _userName = '';
  var _userPassword = '';
  var _userEmail = '';

  //vamos associar ao botão para ativar o validador dos textfields do form
  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    //fecha o softkeyboard
    FocusScope.of(context).unfocus();

    if (isValid) {
      //irá chamar o onSaved de cada textfield
      _formKey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                //ocupar apenas o espaço necessário
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (value) {
                      //return string se houver erro, retorna null se tud ok
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'Email Address'),
                    onSaved: (value) {
                      _userEmail = value!;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('user'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'The user should be at least 4 characters';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'User',
                      ),
                      onSaved: (value) {
                        _userName = value!;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'The password should be at least 7 characters';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _isLogin = !_isLogin;
                    },
                    child: Text(_isLogin ? 'Login' : 'Signup'),
                  ),
                  TextButton(
                    onPressed: _trySubmit,
                    child: Text(_isLogin
                        ? 'Create new account'
                        : 'I already have an account'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
