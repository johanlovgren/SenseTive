
import 'package:flutter/material.dart';
import 'package:sensetive/blocs/profile_bloc.dart';

class ProfileBlocProvider extends InheritedWidget {
  final ProfileBloc profileBloc;

  const ProfileBlocProvider({Key key, Widget child, this.profileBloc})
      : super(key: key, child: child);

  static ProfileBlocProvider of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProfileBlocProvider>());
  }
  @override
  bool updateShouldNotify(ProfileBlocProvider oldWidget)
  => profileBloc != oldWidget.profileBloc;
}