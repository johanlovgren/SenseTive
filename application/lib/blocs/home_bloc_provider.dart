import 'package:flutter/material.dart';
import 'home_bloc.dart';

/// Provider used to pass data between widget/states
///
/// [uid] user id for the current user
/// [homeBloc] BLoC for Home Widget
class HomeBlocProvider extends InheritedWidget {
  final HomeBloc homeBloc;
  final String uid;

  const HomeBlocProvider({Key key, Widget child, this.homeBloc, this.uid})
      : super(key: key, child: child);

  static HomeBlocProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<HomeBlocProvider>();
  }

  @override
  bool updateShouldNotify(HomeBlocProvider old) => homeBloc != old.homeBloc;
}