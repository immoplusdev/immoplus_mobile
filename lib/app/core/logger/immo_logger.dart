import 'package:logger/logger.dart';

enum ImmoLoggerLevelType { debug, info, warning, error }

abstract class ImmoLogger {
  static void d(String message, [dynamic error, StackTrace? stackTrace]) {
    log(message, ImmoLoggerLevelType.debug, error, stackTrace);
  }

  static void i(String message, [dynamic error, StackTrace? stackTrace]) {
    log(message, ImmoLoggerLevelType.info, error, stackTrace);
  }

  static void w(String message, [dynamic error, StackTrace? stackTrace]) {
    log(message, ImmoLoggerLevelType.warning, error, stackTrace);
  }

  static void e(String message, [dynamic error, StackTrace? stackTrace]) {
    log(message, ImmoLoggerLevelType.error, error, stackTrace);
  }

  static void log(String message, ImmoLoggerLevelType type,
      [dynamic error, StackTrace? stackTrace]) {
    var logger = Logger();

    switch (type) {
      case ImmoLoggerLevelType.debug:
        logger.d(message, error: error, stackTrace: stackTrace);
        break;
      case ImmoLoggerLevelType.info:
        logger.i(message, error: error, stackTrace: stackTrace);
        break;
      case ImmoLoggerLevelType.warning:
        logger.w(message, error: error, stackTrace: stackTrace);
        break;
      case ImmoLoggerLevelType.error:
        logger.e(message, error: error, stackTrace: stackTrace);
        break;
    }
  }
}
