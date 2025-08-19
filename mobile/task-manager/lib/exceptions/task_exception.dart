import 'app_exception.dart';

class TaskException extends AppException {
  TaskException(String message, {int? code}) : super(message, code: code);
}
