import 'dart:async';

/// Validators used to ensure email and password are valid
class Validators {
  /// Validates an email
  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData:
      (email, sink) {
        if (email.contains('@') && email.contains('.')) {
          sink.add(email);
        } else if (email.length > 0 ) {
          sink.addError('Enter a valid email');
        }
      });

  /// Validates a password
  final validatePassword = StreamTransformer<String, String>.fromHandlers(handleData:
  (password, sink) {
    if (password.length >= 6) {
      sink.add(password);
    } else if (password.length > 0) {
      sink.addError('Password needs to be at least 6 characters');
    }
  });

  final validateName = StreamTransformer<String, String>.fromHandlers(handleData:
  (name, sink) {
    if (name.length > 0) {
      sink.add(name);
    } else {
      sink.addError('You must enter a name');
    }
  });
}