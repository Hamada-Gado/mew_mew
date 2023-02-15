import 'package:mew_mew/exceptions/exception_handler.dart';

class SocketExceptionW extends ExceptionHandlerW {
  const SocketExceptionW({required super.retry, super.key})
      : super(
          message:
              "An error ocurred, the reason might be that their is no internet connection. Check your internet connection and try again.",
        );
}
