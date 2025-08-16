import 'app_exception.dart';

class AuthException extends AppException {
  AuthException(String message, {int? code}) : super(message, code: code);
}


