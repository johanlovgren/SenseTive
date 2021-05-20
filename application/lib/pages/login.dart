import 'dart:async';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sensetive/blocs/login_bloc.dart';
import 'package:sensetive/services/firebase_authentication.dart';
import 'package:sensetive/widgets/background_image.dart';


const String _privacyPolicy = 'SenseTive collects personal identification information, name and email, when creating an account and readings collected by the sensor kit.\nThe data is used to manage your account and ensure the application works properly. The data is stored securely until the account is deleted by the user. You have the right to access your personal data, correct any information you believe is inaccurate and erase the data. If you have any questions about SenseTive\'s privacy policy or wish to report a complaint you may contact us at info@negentropy.se.';
const String _backgroundImagePath = 'lib/assets/images/pregnant_woman.jpg';
const String _sensetiveTextImage = 'lib/assets/images/sensetive_text_white.png';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginBloc _loginBloc;
  StreamSubscription errorSubscription;


  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc(FirebaseAuthenticationService());
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

    _loginBloc.createAccountDialog.listen((message) {
      if (message.contains('error'))
        _showAlertDialog(
            'Create account error',
            message,
            actions: _defaultAlertButtons()
        );
      else
        _showAlertDialog(
            'Account created',
            'Email verification sent',
            actions: _defaultAlertButtons());
    });
    errorSubscription = _loginBloc.authenticationApi.loginError.listen((message) {
      _showAlertDialog(
          'Login error',
          message,
          actions: _defaultAlertButtons()
      );
    });
  }


  @override
  void dispose() {
    errorSubscription.cancel();
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            //_backgroundImageWidget(),
            const BackgroundImage(imagePath: _backgroundImagePath),
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

  /// Builds the Login widget
  Column _buildLoginWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(64),
          child: Image(image: AssetImage(_sensetiveTextImage)),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white.withOpacity(0.5),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: _loginFormWidget(),
          ),
        )
      ],
    );
  }

  /// Builds the login form widgets
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
        _buttonsLogin(),
        //_buildLoginAndCreateButtons()
      ],
    );
  }

  /// Builds the login/create account buttons
  Widget _buttonsLogin() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StreamBuilder(
          initialData: false,
          stream: _loginBloc.enableLoginButton,
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
          onPressed: () async {
            bool createAccount = await _showCreateAccountDialog();
            if (createAccount != null && createAccount) {
              _loginBloc.loginOrCreateChanged.add('Create Account');
            }
          },
        )
      ],
    );
  }

  /// Shows the create account dialog, if the user enters valid credentials
  /// True is returned to create an account
  Future<bool> _showCreateAccountDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Create account'),
            content: _createAccountDialogContent(context),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              StreamBuilder(
                initialData: false,
                stream: _loginBloc.enableCreateButton,
                builder: (BuildContext context, AsyncSnapshot snapshot)
                =>  ElevatedButton(
                  child: Text('Create Account'),
                  onPressed: snapshot.data
                      ? () => Navigator.of(context).pop(true)
                      : null,
                ),
              ),
            ],
          );
        }
    );
  }

  /// Builds the create account dialog content
  Column _createAccountDialogContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        StreamBuilder(
            stream: _loginBloc.emailCreateAccount,
            builder: (BuildContext context, AsyncSnapshot snapshot) =>
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: _loginBloc.emailChangedCreateAccount.add,
                  decoration: InputDecoration(
                      labelText: 'Email Address',
                      errorText: snapshot.error,
                      icon: Icon(
                        Icons.email_outlined,
                        color: Colors.black,
                      )
                  ),
                )
        ),
        StreamBuilder(
          stream: _loginBloc.passwordCreateAccount,
          builder: (BuildContext context, AsyncSnapshot snapshot) =>
              TextField(
                obscureText: true,
                onChanged: _loginBloc.passwordChangedCreateAccount.add,
                decoration: InputDecoration(
                    labelText: 'Password',
                    errorText: snapshot.error,
                    icon: Icon(
                      Icons.security,
                      color: Colors.black,
                    )
                ),
              ),
        ),
        StreamBuilder(
          stream: _loginBloc.repeatedPasswordCreateAccount,
          builder: (BuildContext context, AsyncSnapshot snapshot) =>
              TextField(
                obscureText: true,
                onChanged: _loginBloc.repeatedPasswordChangedCreateAccount.add,
                decoration: InputDecoration(
                    labelText: 'Repeat Password',
                    errorText: snapshot.error,
                    icon: Icon(
                      Icons.security,
                      color: Colors.black,
                    )
                ),
              ),
        ),
        Row(
          children: [
            StreamBuilder(
              stream: _loginBloc.acceptPrivacy,
              initialData: false,
              builder: (context, snapshot) {
                return Checkbox(
                  value: snapshot.data,
                  onChanged: (newValue) {
                    _loginBloc.acceptPrivacyChanged.add(newValue);
                  },
                );
              },
            ),
            Container(
                width: 200,
                child: RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'I accept the ',
                            style: TextStyle(color: Colors.black)
                        ),
                        TextSpan(
                            text:'Privacy Policy ',
                            recognizer: TapGestureRecognizer()..onTap = () {
                              return showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                        title: Text('Privacy Policy'),
                                        content: SingleChildScrollView(
                                          child: Text(
                                              _privacyPolicy
                                          ),
                                        ),
                                        actions: _defaultAlertButtons()
                                    );
                                  }
                              );
                            },
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline
                            )
                        ),
                        TextSpan(
                            text: 'in order to create an account.',
                            style: TextStyle(color: Colors.black)
                        ),
                      ]
                  ),
                )
            )
          ],
        )
      ],
    );
  }

  Future<void> _showAlertDialog(String alertHeader, String alertMessage,
      {@required List<Widget> actions}) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(alertHeader),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(alertMessage),
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


