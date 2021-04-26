import 'dart:convert';

import 'backend_api.dart';
import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Backend service used to communicate with the backend
class BackendService implements BackendApi {
  final secureStorage = new FlutterSecureStorage();
  final String loginAddress = 'https://rickebo.com/sensetive/login';
  final Map<String, String> header = {
    'Content-Type': 'application/json',
    'Accept-Encoding': '',
    'Charset': 'utf-8'
  };

  /// Sign in the current user with a supported method by the backend
  /// On error, exception is thrown
  ///
  /// [method] what method to sign in with, were the token is received
  /// [token] the token received by the chosen method
  @override
  Future<String> signIn({String method, String token}) async {
    final response = await post(
        loginAddress,
        body: jsonEncode({
          "Method": method,
          "Identifier": token
        }),
        headers: header);

    if (response.statusCode == 200) {
      print(json.decode(response.body));
      String jwtToken = jsonDecode(response.body)['token'];
      return jwtToken;
    } else {
      throw(Exception('Server connection error: ${response.statusCode}'));
    }
  }
}