import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/auth.dart';

//utilizamos para trocar o que será renderizado na tela
enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  static const routeName = '/auth-screen';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      //colocamos widgets uma em cima da outra em um espaço tridimensional
      body: Stack(
        children: [
          //base do Stack, que basicamente é o gradiente
          Container(
            decoration: BoxDecoration(
              //mais um exemplo de uso de gradiente
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          //Colocamos o item abaixo acima do gradiente praticamente
          //definimos toda a altura e largura do device para existir um scroll
          //O SingleChildScrollView precisa de um tamanho definido
          SingleChildScrollView(
            child: Container(
              width: deviceSize.width,
              height: deviceSize.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    //container que exibe o MyShop
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      //inclina o container
                      //Podemos colocar scaling, offset
                      /*usamos também os .. () que basicamente significa que o
                       o retorno para transform sera do rotationZ() e não do translate
                       pois o translate() retorna void e o parametro requer um Matrix4
                       que é proviniente de rotationZ()
                       
                       o uso de .. também evita o uso de mais linhas
                       final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
                        transformConfig.translate(-10.0);
                       */

                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        'My Shop',
                        style: TextStyle(
                          color: Theme.of(context)
                              .accentTextTheme
                              .headline6!
                              .color,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({Key? key}) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();

  AuthMode _authMode = AuthMode.Login;

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  var _isLoading = false;
  final _passwordController = TextEditingController();
  late AnimationController _controller;
  //Precisamos dizer para a classe genérica o que queremos animar
  //size, width, height ou offset
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    //vsync significa um pointer para o animationController controlar a widget
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    //Classe Tween vem de between e representa animação dado um inicio e fim
    _slideAnimation =
        Tween<Offset>(begin: Offset(0, 1.5), end: Offset(0, 0)).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
    );
    //Não precisamos adicionar um listener por conta das built-in widgets
    // _heightAnimation.addListener(() => setState(() {}));

    //Para utilização na FadeTransition
    //0 - invisivel - 1 - completamente visivel
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('An error occured'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text('Okay'),
              )
            ],
          );
        });
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      //Invalid;
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        //log user in
        await Provider.of<Auth>(context, listen: false).signin(
          _authData['email'] as String,
          _authData['password'] as String,
        );
      } else {
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['email'] as String,
          _authData['password'] as String,
        );
      }
    } on HttpException catch (error) {
      //com essa sintaxe filtramos os erros que queremos catch
      //basicamente tudo que entrar naquele IF de auth.dart
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'This is not a valid password';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      //usamos essa sintaxe para os demais erros genericos que não sejam HttpException

      const errorMessage = 'Could not authenticate you. Please try again later';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      //forma mais eficiente de animar um Container
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.Signup ? 320 : 260,
        // height: _heightAnimation.value.height,
        constraints: BoxConstraints(
          minHeight: _authMode == AuthMode.Signup ? 320 : 260,
        ),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16),

        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid Email!';
                    }
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Passoword is too short';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  //não exibimos um container caso o modo de autenticação seja o signup
                  constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                    maxHeight: _authMode == AuthMode.Signup ? 120 : 0,
                  ),
                  curve: Curves.easeIn,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: TextFormField(
                        enabled: _authMode == AuthMode.Signup,
                        decoration:
                            InputDecoration(labelText: 'Confirm Password'),
                        obscureText: true,
                        validator: _authMode == AuthMode.Signup
                            ? (value) {
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  ElevatedButton(
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 8,
                      ),
                      onPrimary:
                          Theme.of(context).primaryTextTheme.button!.color,
                      textStyle: TextStyle(
                        color: Theme.of(context).primaryTextTheme.button!.color,
                      ),
                    ),
                  ),
                TextButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 4,
                    ),
                    textStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
