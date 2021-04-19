import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sensetive/blocs/login_bloc.dart';
import 'package:sensetive/services/authentication.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginBloc _loginBloc;


  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc(AuthenticationService());
    _loginBloc.loginError.listen((errorMessage) {
      List<Widget> actions = _defaultAlertButtons();
      if (errorMessage.contains('verified'))
        actions.add(
            ElevatedButton(
                child: Text('Send verification email'),
                onPressed: () {
                  _loginBloc.loginOrCreateChanged.add('Send verification email');
                  Navigator.of(context).pop();
                }
            ));
      _showAlertDialog(
          'Login error',
          errorMessage,
          actions: actions);
    });

    _loginBloc.createAccountError.listen((errorMessage) {
      _showAlertDialog(
          'Create account error',
          errorMessage,
          actions: _defaultAlertButtons()
      );
    });
  }


  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            _backgroundImageWidget(),
            SafeArea(
              child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Stack(
                    children: [
                      _buildLoginWidget(),
                    ],
                  )
              ),
            )
          ],
        )
    );
  }

  Container _backgroundImageWidget() {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fitHeight,
              image: AssetImage('lib/assets/images/pregnant_woman.jpg')
          )
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
            sigmaX: 3.0,
            sigmaY: 3.0
        ),
        child: Container(
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
        ),
      ),
    );
  }

  Column _buildLoginWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(64),
          child: Image(image: AssetImage('lib/assets/images/sensetive_text_white.png')),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white.withOpacity(0.5)
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: _loginFormWidget(),
          ),
        )
      ],
    );
  }

  Column _loginFormWidget() {
    return Column(
      children: [
        StreamBuilder(
            stream: _loginBloc.email,
            builder: (BuildContext context, AsyncSnapshot snapshot)
            => TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  labelText: 'Email Address',
                  icon: Icon(
                    Icons.mail_outline,
                    color: Colors.black,
                  ),
                  errorText: snapshot.error
              ),
              onChanged: _loginBloc.emailChanged.add,
            )
        ),
        StreamBuilder(
            stream: _loginBloc.password,
            builder: (BuildContext context, AsyncSnapshot snapshot)
            => TextField(
              obscureText: true,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                  labelText: 'Password',
                  icon: Icon(
                      Icons.security,
                      color: Colors.black
                  ),
                  errorText: snapshot.error
              ),
              onChanged: _loginBloc.passwordChanged.add,
            )
        ),
        SizedBox(height: 48,),
        _buildLoginAndCreateButtons()
      ],
    );
  }

  Widget _buildLoginAndCreateButtons() {
    return StreamBuilder(
      initialData: 'Login',
      stream: _loginBloc.loginOrCreateButton,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == 'Login') {
          return _buttonsLogin();
        } else if (snapshot.data == 'Create Account') {
          return _buttonsCreateAccount();
        }
        return Container(width: 0, height: 0,);
      },
    );
  }

  Widget _buttonsLogin() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StreamBuilder(
          initialData: false,
          stream: _loginBloc.enableLoginCreateButton,
          builder: (BuildContext context, AsyncSnapshot snapshot)
          =>  ElevatedButton(
            child: Text('Login'),
            onPressed: snapshot.data
                ? () => _loginBloc.loginOrCreateChanged.add('Login')
                : null,
          ),
        ),
        TextButton(
          child: Text('Create Account'),
          onPressed: (){
            _loginBloc.loginOrCreateButtonChanged.add('Create Account');
          },
        )
      ],
    );
  }

  Widget _buttonsCreateAccount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StreamBuilder(
          initialData: false,
          stream: _loginBloc.enableLoginCreateButton,
          builder: (BuildContext context, AsyncSnapshot snapshot)
          => ElevatedButton(
            child: Text('Create Account'),
            onPressed: snapshot.data
                ? () {
              _loginBloc.loginOrCreateChanged.add('Create Account');
              _loginBloc.loginOrCreateButtonChanged.add('Login');
              _showAlertDialog('Account created', 'Email verification sent', actions: _defaultAlertButtons());
            }
                : null,
          ),
        ),
        TextButton(
          child: Text('Login'),
          onPressed: () {
            _loginBloc.loginOrCreateButtonChanged.add('Login');
          },
        )
      ],
    );
  }

  Future<void> _showAlertDialog(String alertHeader, String alertMessage,
      {@required List<Widget> actions}) async{
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(alertHeader),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(alertMessage)
                  ],
                ),
              ),
              actions: actions
          );
        });
  }

  List<Widget> _defaultAlertButtons() {
    return [
      TextButton(
        child: Text('Close'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      )
    ];
  }
}
