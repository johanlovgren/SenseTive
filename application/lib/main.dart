import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sensetive/pages/home.dart';
import 'package:sensetive/pages/login.dart';

import 'package:sensetive/blocs/authentication_bloc.dart';
import 'package:sensetive/blocs/authentication_bloc_provider.dart';
import 'package:sensetive/blocs/home_bloc.dart';
import 'package:sensetive/blocs/home_bloc_provider.dart';
import 'package:sensetive/services/authentication.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AuthenticationService _authenticationService;//= AuthenticationService();
    AuthenticationBloc _authenticationBloc;// = AuthenticationBloc(_authenticationService);


    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Container();
        }
        else if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.white,
            child: CircularProgressIndicator(),
          );
        } else {
          _authenticationService = AuthenticationService();
          _authenticationBloc = AuthenticationBloc(_authenticationService);
          return AuthenticationBlocProvider(
              authenticationBloc: _authenticationBloc,
              child: StreamBuilder(
                initialData: null,
                stream: _authenticationBloc.user,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      color: Colors.white,
                      child: CircularProgressIndicator(),
                    );
                  } else if(snapshot.hasData) {
                    return HomeBlocProvider(
                      homeBloc: HomeBloc(
                          _authenticationService
                      ),
                      uid: snapshot.data,
                      child: _buildMaterialApp(Home()),
                    );
                  } else {
                    return _buildMaterialApp(Login());
                  }
                },
              )
          );
        }
      },
    );
  }

  MaterialApp _buildMaterialApp(Widget homePage) {
    return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'SenseTive',
    theme: ThemeData(
      primarySwatch: Colors.indigo,
    ),
    home: homePage,
  );
  }
}
