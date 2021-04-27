import 'package:flutter/material.dart';
import 'package:sensetive/blocs/authentication_bloc.dart';

/// AuthenticationBlocProvider used to transfer AuthenticationBloc's between
/// widgets
class AuthenticationBlocProvider extends InheritedWidget {
  final AuthenticationBloc authenticationBloc;

  const AuthenticationBlocProvider({Key key, Widget child, this.authenticationBloc})
  : super(key: key, child: child);

  static AuthenticationBlocProvider of(BuildContext context){
    return (context.dependOnInheritedWidgetOfExactType<AuthenticationBlocProvider>());
  }

  @override
  bool updateShouldNotify(AuthenticationBlocProvider oldWidget) =>
      authenticationBloc != oldWidget.authenticationBloc;
}