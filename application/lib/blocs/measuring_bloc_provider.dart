
import 'package:flutter/material.dart';
import 'package:sensetive/blocs/measuring_bloc.dart';
class MeasuringBlocProvider extends InheritedWidget {
  final MeasuringBloc measuringBloc;
  const MeasuringBlocProvider({Key key, Widget child, this.measuringBloc})
      : super(key: key, child: child);

  static MeasuringBlocProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MeasuringBlocProvider>();
  }

  @override
  bool updateShouldNotify(MeasuringBlocProvider oldWidget)
  => measuringBloc != oldWidget.measuringBloc;
}