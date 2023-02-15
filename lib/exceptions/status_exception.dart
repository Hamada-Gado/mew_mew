import 'package:mew_mew/exceptions/exception_handler.dart';

class StatusException implements Exception {
  int statusCode;

  StatusException(this.statusCode);
}

class StatusExceptionW extends ExceptionHandlerW {
  const StatusExceptionW(
      {required int statusCode, required super.retry, super.key})
      : super(
          message: "Unhandled Error: Status code is $statusCode",
        );
}
