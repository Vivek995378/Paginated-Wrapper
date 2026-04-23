import 'dart:io';

import 'package:dio/dio.dart';

import '../../response_classes/network_response.dart';
import 'api_constants.dart';
import 'core_dio_singleton.dart';

class CoreCommunicationManager {
  final CoreDioClient _dioClient;

  CoreCommunicationManager({required CoreDioClient dioClient})
      : _dioClient = dioClient;

  Future<NetworkResponse> get({
    required String baseUrl,
    required String urlEndPoint,
    required Map<String, dynamic> headers,
    bool clearPreviousDioInstance = false,
    Map<String, dynamic>? queryParams,
    Duration connectionTimeOut = const Duration(seconds: 30),
    Duration receiveTimeOut = const Duration(seconds: 30),
    Duration sendTimeOut = const Duration(seconds: 30),
    ResponseType responseType = ResponseType.json,
  }) async {
    try {
      final response = await _dioClient
          .getDioClient(
            baseUrl: baseUrl,
            connectionTimeOut: connectionTimeOut,
            receiveTimeOut: receiveTimeOut,
            sendTimeOut: sendTimeOut,
            headers: headers,
            responseType: responseType,
            clearPreviousDioInstance: clearPreviousDioInstance,
          )
          .get(urlEndPoint, queryParameters: _buildQueryParams(queryParams));
      return NetworkSuccessResponse(response);
    } on DioException catch (error) {
      return _handleDioError(error);
    } catch (error) {
      return NetworkUnknownError(error);
    }
  }

  Map<String, dynamic> _buildQueryParams(Map<String, dynamic>? queryParams) {
    final params = queryParams ?? <String, dynamic>{};
    params.putIfAbsent(
      ApiConstants.paramSrcKey,
      () => Platform.isAndroid
          ? ApiConstants.paramSrcValueAndroid
          : ApiConstants.paramSrcValueIos,
    );
    return params;
  }

  Future<NetworkResponse> _handleDioError(DioException error) async {
    if (error.response != null) {
      return NetworkServerError(error.response, error);
    } else if (error.type == DioExceptionType.connectionError) {
      return NetworkConnectionError(error.type);
    }
    return NetworkUnknownError(error);
  }

  Future<List<NetworkResponse>> performParallelRequests(
    List<Future<NetworkResponse>> requests,
  ) async {
    return Future.wait(
      requests.map(
        (future) => future.catchError((e) async {
          if (e is DioException) {
            return await _handleDioError(e);
          }
          return NetworkUnknownError(e);
        }),
      ),
      eagerError: false,
      cleanUp: (_) {},
    );
  }
}
