import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  //vamos associar ao botão
  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {}
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
                    validator: (value) {
                      //return string se houver erro, retorna null se tud ok
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'Email Address'),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty || value.length < 4) {
                        return 'The user should be at least 4 characters';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'User',
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'The password should be at least 7 characters';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  ElevatedButton(onPressed: () {}, child: Text('Login')),
                  TextButton(
                      onPressed: () {}, child: Text('Create new account')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
