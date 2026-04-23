import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart' as logger_package;

class AppLogger {
  static final logger_package.Logger _logger = logger_package.Logger(
    printer: logger_package.PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: logger_package.DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  static bool get _shouldLog {
    if (kReleaseMode) {
      return false;
    }
    return true;
  }

  static void logError(
      String message, {
        Object? error,
        StackTrace? stackTrace,
        Map<String, dynamic>? data,
      }) {
    if (!_shouldLog) return;

    if (data != null) {
      _logger.e('$message\nData: $data', error: error, stackTrace: stackTrace);
    } else {
      _logger.e(message, error: error, stackTrace: stackTrace);
    }
  }

  static void logWarning(String message, {Map<String, dynamic>? data}) {
    if (!_shouldLog) return;

    if (data != null) {
      _logger.w('$message\nData: $data');
    } else {
      _logger.w(message);
    }
  }

  static void logInfo(String message, {Map<String, dynamic>? data}) {
    if (!_shouldLog) return;

    if (data != null) {
      _logger.i('$message\nData: $data');
    } else {
      _logger.i(message);
    }
  }

  static void logDebug(String message, {Map<String, dynamic>? data}) {
    if (!_shouldLog) return;

    if (data != null) {
      _logger.d('$message\nData: $data');
    } else {
      _logger.d(message);
    }
  }

  static void logTrace(String message, {Map<String, dynamic>? data}) {
    if (!_shouldLog) return;

    if (data != null) {
      _logger.t('$message\nData: $data');
    } else {
      _logger.t(message);
    }
  }

  static void logFatal(
      String message, {
        Object? error,
        StackTrace? stackTrace,
        Map<String, dynamic>? data,
      }) {
    if (!_shouldLog) return;

    if (data != null) {
      _logger.f('$message\nData: $data', error: error, stackTrace: stackTrace);
    } else {
      _logger.f(message, error: error, stackTrace: stackTrace);
    }
  }
}
