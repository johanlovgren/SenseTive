import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sensetive/blocs/backend_authentication_bloc.dart';
import 'package:sensetive/blocs/welcome_bloc.dart';
import 'package:sensetive/pages/home.dart';
import 'package:sensetive/pages/login.dart';
import 'package:sensetive/blocs/authentication_bloc_provider.dart';
import 'package:sensetive/blocs/home_bloc.dart';
import 'package:sensetive/blocs/home_bloc_provider.dart';
import 'package:sensetive/services/firebase_authentication.dart';
import 'package:sensetive/services/backend.dart';
import 'package:sensetive/pages/welcome.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FirebaseAuthenticationService _firebaseAuthenticationService;
    BackendAuthenticationBloc _authenticationBloc;
    BackendService _backendService;
    WelcomeBloc _welcomeBloc = WelcomeBloc();

    // Needed for Firebase authentication
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
          _firebaseAuthenticationService = _firebaseAuthenticationService == null
              ? FirebaseAuthenticationService()
              : _firebaseAuthenticationService;
          _backendService = _backendService == null
              ? BackendService()
              : _backendService;
          _authenticationBloc = _authenticationBloc == null
              ? BackendAuthenticationBloc(_backendService, _firebaseAuthenticationService)
              : _authenticationBloc;

          // Until user is authenticated, show login page
          // When user is authenticated, token is added to stream and
          // the user is taken to the home page
          return AuthenticationBlocProvider(
              authenticationBloc: _authenticationBloc,
              child: StreamBuilder(
                initialData: null,
                stream: _authenticationBloc.user,
                builder: (BuildContext context, AsyncSnapshot jwtSnapshot) {
                  if (jwtSnapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      color: Colors.white,
                      child: CircularProgressIndicator(),
                    );
                  } else if(jwtSnapshot.hasData) {
                    _welcomeBloc.addJwt.add(jwtSnapshot.data);
                    return StreamBuilder(
                      stream: _welcomeBloc.userDataExists,
                      initialData: null,
                      builder: (context, userDataExistsSnapshot) {
                        if (userDataExistsSnapshot.connectionState == ConnectionState.waiting)
                          return Container(
                            color: Colors.white,
                            child: CircularProgressIndicator(),
                          );
                        else if (userDataExistsSnapshot.hasData && userDataExistsSnapshot.data)
                          return HomeBlocProvider(
                            homeBloc: HomeBloc(
                              _firebaseAuthenticationService,
                            ),
                            jwt: jwtSnapshot.data,
                            child: _buildMaterialApp(Home()),
                          );
                        else
                          return _buildMaterialApp(Welcome());
                      },
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
