import 'package:dio/dio.dart';

import '../../logger/app_logger.dart';

class CoreDioInterceptor implements Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.logInfo(
      '<<<<<<<<<<----------API SUCCESS DATA---------->>>>>>>>>>',
    );
    AppLogger.logInfo(
      '<<--METHOD-->>==${response.requestOptions.method}\n'
      '<<--STATUS_CODE-->>==${response.statusCode}\n'
      '<<--BASE_URL-->>==${response.requestOptions.baseUrl}\n'
      '<<--END_POINT-->>==${response.requestOptions.path}\n'
      '<<--HEADERS-->>==${response.requestOptions.headers}\n'
      '<<--QUERY_PARAMETERS-->>==${response.requestOptions.queryParameters}\n'
      '<<--DATA_PARAMETERS-->>==${response.requestOptions.data}\n'
      '<<--RESPONSE_DATA-->>==${response.data}\n',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.logInfo(
      '<<<<<<<<<<----------API ERROR DATA---------->>>>>>>>>>',
    );
    AppLogger.logInfo(
      '<<--METHOD-->>==${err.requestOptions.method}\n'
      '<<--ERROR-->>==${err.error}\n'
      '<<--BASE_URL-->>==${err.requestOptions.baseUrl}\n'
      '<<--END_POINT-->>==${err.requestOptions.path}\n'
      '<<--HEADERS-->>==${err.requestOptions.headers}\n'
      '<<--QUERY_PARAMETERS-->>==${err.requestOptions.queryParameters}\n'
      '<<--DATA_PARAMETERS-->>==${err.requestOptions.data}\n'
      '<<--RESPONSE_DATA-->>==${err.response?.data ?? ''}\n',
    );
    handler.next(err);
  }
}
