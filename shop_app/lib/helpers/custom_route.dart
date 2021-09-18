import 'package:flutter/material.dart';

//usamos para single routes on fly creation
class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
  }) : super(
          builder: builder,
          settings: settings,
        );

  //podemos setar nossa própria animação sobreescrevendo este método
  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    //checa se é a rota inicial ou primeira tela
    if (settings.name == '/') {
      return child;
    }
    //
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

//usamos para afetar a transição de todas as routes
class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  //podemos setar nossa própria animação sobreescrevendo este método
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    //checa se é a rota inicial ou primeira tela
    if (route.settings.name == '/') {
      return child;
    }
    //
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
