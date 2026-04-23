import 'package:dio/dio.dart';

sealed class NetworkResponse {}

class NetworkSuccessResponse extends NetworkResponse {
  final Response response;

  NetworkSuccessResponse(this.response);

  int get code => response.statusCode ?? 0;

  Headers get headers => response.headers;

  dynamic get data => response.data;
}

sealed class NetworkErrorResponse extends NetworkResponse {}

class NetworkServerError extends NetworkErrorResponse {
  final Response? response;
  final DioException dioException;

  NetworkServerError(this.response, this.dioException);
}

class NetworkConnectionError extends NetworkErrorResponse {
  final DioExceptionType dioExceptionType;

  NetworkConnectionError(this.dioExceptionType);
}

class NetworkUnknownError extends NetworkErrorResponse {
  dynamic exception;

  NetworkUnknownError(this.exception);
}
