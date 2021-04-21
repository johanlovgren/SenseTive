import 'dart:convert';

import 'backend_api.dart';
import 'package:http/http.dart';


class BackendService implements BackendApi {
  final String loginAddress = 'https://rickebo.com/sensetive/login';
  final Map<String, String> header = {
    'Content-Type': 'application/json',
    'Accept-Encoding': 'gzip, deflate, br',
    'Charset': 'utf-8'
  };

  @override
  Future<String> signIn({String method, String token}) async {
    // TODO: implement signIn
    String body = jsonEncode({
      "Method": method,
      "Identifier": token
    });
    final response = await post(loginAddress, body: body, headers: header);
    if (response.statusCode == 200) {
      print(jsonDecode(response.body.toString()));
      Map<String, dynamic> body = jsonDecode(response.body);
      return body['token'];
    } else {
      throw Exception("Server connection error: ${response.statusCode}");
    }
  }

  @override
  Future<String> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }
}