import 'package:dio/dio.dart';

import '../interceptor/core_dio_interceptor.dart';

class CoreDioClient {
  final Map<String, Dio> _instances = <String, Dio>{};

  Dio getDioClient({
    required String baseUrl,
    required Duration connectionTimeOut,
    required Duration receiveTimeOut,
    required Duration sendTimeOut,
    required Map<String, dynamic> headers,
    required ResponseType responseType,
    required bool clearPreviousDioInstance,
  }) {
    final key = _buildKey(baseUrl, headers);

    if (_instances.containsKey(key) && !clearPreviousDioInstance) {
      return _instances[key]!;
    }

    final dio = _createDio(
      baseUrl: baseUrl,
      connectionTimeOut: connectionTimeOut,
      receiveTimeOut: receiveTimeOut,
      sendTimeOut: sendTimeOut,
      headers: headers,
      responseType: responseType,
    );
    _instances[key] = dio;
    return dio;
  }

  String _buildKey(String baseUrl, Map<String, dynamic> headers) {
    return '$baseUrl-${headers.hashCode}';
  }

  Dio _createDio({
    required String baseUrl,
    required Duration connectionTimeOut,
    required Duration receiveTimeOut,
    required Duration sendTimeOut,
    required Map<String, dynamic> headers,
    required ResponseType responseType,
  }) {
    final dio = Dio(
      BaseOptions(
        receiveTimeout: receiveTimeOut,
        connectTimeout: connectionTimeOut,
        sendTimeout: sendTimeOut,
        followRedirects: false,
        baseUrl: baseUrl,
        headers: headers,
        responseType: responseType,
      ),
    );

    dio.interceptors.addAll([
      CoreDioInterceptor(),
    ]);

    return dio;
  }
}
