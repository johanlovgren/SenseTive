
import 'package:flutter/cupertino.dart';
import 'package:sensetive/blocs/welcome_bloc.dart';

class WelcomeBlocProvider extends InheritedWidget {
  final WelcomeBloc welcomeBloc;

  const WelcomeBlocProvider({Key key, Widget child, this.welcomeBloc})
  : super(key: key, child: child);

  static WelcomeBlocProvider of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<WelcomeBlocProvider>());
  }

  @override
  bool updateShouldNotify(WelcomeBlocProvider oldWidget) =>
      welcomeBloc != oldWidget.welcomeBloc;
}