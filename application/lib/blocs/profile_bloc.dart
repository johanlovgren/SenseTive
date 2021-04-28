import 'dart:async';

class ProfileBloc {

  /// Stream for the users name
  final StreamController<String> _nameController = StreamController<String>();
  Sink<String> get _addName => _nameController.sink;
  Stream<String> get name => _nameController.stream;
  /// Stream for the users email
  final StreamController<String> _emailController = StreamController<String>();
  Sink<String> get _addEmail => _emailController.sink;
  Stream<String> get email => _emailController.stream;

  void dispose() {
    _nameController.close();
    _emailController.close();
  }
}