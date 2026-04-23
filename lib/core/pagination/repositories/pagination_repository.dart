import '../../communication/api/api_constants.dart';
import '../../communication/api/core_communication_manager.dart';
import '../../env/app_env.dart';
import '../../response_classes/network_response.dart';
import '../models/pagination_models.dart';

abstract class PaginationRepository<T extends PaginatedItem> {
  Future<PaginationResponse<T>> fetchPage({
    required String endpoint,
    required int page,
    required int pageSize,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  });
}

class PaginationRepositoryImpl<T extends PaginatedItem>
    implements PaginationRepository<T> {
  final CoreCommunicationManager _communicationManager;
  final T Function(Map<String, dynamic>) _itemFromJson;

  PaginationRepositoryImpl({
    required CoreCommunicationManager communicationManager,
    required T Function(Map<String, dynamic>) itemFromJson,
  })  : _communicationManager = communicationManager,
        _itemFromJson = itemFromJson;

  @override
  Future<PaginationResponse<T>> fetchPage({
    required String endpoint,
    required int page,
    required int pageSize,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    try {
      final params = _buildQueryParams(
        page: page,
        pageSize: pageSize,
        customParams: queryParams,
      );

      final response = await _communicationManager.get(
        baseUrl: AppEnv.baseUrl,
        urlEndPoint: endpoint,
        headers: {ApiConstants.contentType: ApiConstants.contentTypeValue},
        queryParams: params,
      );

      return _handleResponse(response, pageSize);
    } catch (e) {
      if (e is PaginationError) rethrow;
      throw PaginationError.unknown(e.toString());
    }
  }

  Map<String, dynamic> _buildQueryParams({
    required int page,
    required int pageSize,
    Map<String, dynamic>? customParams,
  }) {
    final params = <String, dynamic>{
      '_page': page,
      '_limit': pageSize,
    };
    if (customParams != null) {
      params.addAll(customParams);
    }
    return params;
  }

  PaginationResponse<T> _handleResponse(
    NetworkResponse response,
    int pageSize,
  ) {
    if (response is NetworkSuccessResponse) {
      return _handleSuccessResponse(response, pageSize);
    } else if (response is NetworkServerError) {
      throw PaginationError.server(_extractErrorMessage(response));
    } else if (response is NetworkConnectionError) {
      throw PaginationError.network();
    } else if (response is NetworkUnknownError) {
      throw PaginationError.unknown(
        response.exception?.toString() ?? 'An unexpected error occurred',
      );
    }
    throw PaginationError.unknown('Unknown response type');
  }

  PaginationResponse<T> _handleSuccessResponse(
    NetworkSuccessResponse response,
    int pageSize,
  ) {
    final statusCode = response.code;

    if (statusCode < 200 || statusCode >= 300) {
      throw _mapStatusCodeToError(statusCode);
    }

    final data = response.data;

    if (data is List) {
      final items = data
          .map((item) => _itemFromJson(item as Map<String, dynamic>))
          .toList();
      return PaginationResponse(
        items: items,
        currentPage: 0,
        totalPages: 0,
        totalItems: items.length,
        hasMore: items.length == pageSize,
      );
    }

    if (data is! Map<String, dynamic>) {
      throw PaginationError.parsing('Invalid response format');
    }

    return PaginationResponse.fromJson(data, _itemFromJson, pageSize);
  }

  PaginationError _mapStatusCodeToError(int statusCode) {
    if (statusCode == 401 || statusCode == 403) {
      return PaginationError.server('Authentication failed');
    } else if (statusCode == 404) {
      return PaginationError.server('Resource not found');
    } else if (statusCode >= 500) {
      return PaginationError.server('Server error occurred');
    }
    return PaginationError.server('Request failed with status $statusCode');
  }

  String _extractErrorMessage(NetworkServerError error) {
    try {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        final message = data['message'] as String? ??
            data['error'] as String? ??
            data['msg'] as String?;
        if (message != null && message.isNotEmpty) return message;
      }
      final dioMessage = error.dioException.message;
      if (dioMessage != null && dioMessage.isNotEmpty) return dioMessage;
    } catch (_) {}
    return 'Server error occurred';
  }
}
