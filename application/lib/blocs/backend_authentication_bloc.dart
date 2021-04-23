import 'dart:async';
import 'dart:convert';
import 'package:sensetive/blocs/authentication_bloc.dart';
import 'package:sensetive/services/external_authentication_api.dart';
import 'package:sensetive/services/backend_api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final String tokenKey = 'jwtToken';

/// Authentication BLoC used for SenseTive backend service
///
/// [backendApi] is the API used to communicate with the backend
/// [externalAuthenticationApi] is the external authentication service
/// used to authenticate the users.
class BackendAuthenticationBloc implements AuthenticationBloc {
  final secureStorage = new FlutterSecureStorage();
  final BackendApi backendApi;
  final ExternalAuthenticationApi externalAuthenticationApi;


  final StreamController<String> _authenticationController = StreamController<String>();
  Sink<String> get addUser => _authenticationController.sink;
  Stream<String> get user => _authenticationController.stream;
  final StreamController<bool> _logoutController = StreamController<bool>();
  Sink<bool> get addLogoutUser => _logoutController.sink;
  Stream<bool> get listLogoutUser => _logoutController.stream;

  BackendAuthenticationBloc(this.backendApi, this.externalAuthenticationApi) {
    _init();
  }

  /// Initialises the BLoC, checking for existing JWT token and starting listeners
  void _init() async {
    String jwtToken = await secureStorage.read(key: tokenKey);
    if (jwtToken != null && _jwtTokenValid(jwtToken))
      addUser.add(jwtToken);
    else
      addUser.add(null);

    externalAuthenticationApi.loginUser.listen((event) {
      backendApi.signIn(method: event.method, token: event.token).then((jwtToken) {
        secureStorage.write(key: tokenKey, value: jwtToken);
        addUser.add(jwtToken);
      })
      .catchError((error) {
        externalAuthenticationApi.addLoginError.add(error.message);
      });
    });
    listLogoutUser.listen((logout) {
      if (logout == true) {
        secureStorage.delete(key: tokenKey);
        externalAuthenticationApi.signOut();
        addUser.add(null);
      }
    });
  }

  /// Dispose the BLoC, closing controllers
  void dispose() {
    _authenticationController.close();
    _logoutController.close();
  }

  /// Check if JWT token is valid
  ///
  /// [jwtToken] full JWT token to be controlled for validity
  bool _jwtTokenValid(String jwtToken) {
    List<String> jwt = jwtToken.split('.');
    if (jwt.length != 3) {
      return false;
    }
    String encoded = jwt[1].replaceAll('-', '+').replaceAll('_', '/');
    while (encoded.length %4 != 0)
      encoded+= '=';
    Map<String, dynamic> payload = json.decode(utf8.decode(base64Url.decode(encoded)));

    if(DateTime.parse(payload['exp']).isBefore(DateTime.now())) {
      return false;
    }
    return true;
  }
}

