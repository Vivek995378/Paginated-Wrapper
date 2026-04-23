abstract class PaginatedItem {
  int get id;
}

class PaginationConfig {
  final int pageSize;

  final int initialPage;

  const PaginationConfig({
    this.pageSize = 10,
    this.initialPage = 0,
  });

  PaginationConfig copyWith({
    int? pageSize,
    int? initialPage,
    bool? useCursorPagination,
  }) {
    return PaginationConfig(
      pageSize: pageSize ?? this.pageSize,
      initialPage: initialPage ?? this.initialPage,
    );
  }
}

class PaginationResponse<T extends PaginatedItem> {
  final List<T> items;

  final int currentPage;

  final int totalPages;

  final int totalItems;

  final bool hasMore;

  const PaginationResponse({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.hasMore,
  });

  factory PaginationResponse.fromJson(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic>) itemFromJson,
      int pageSize,
      ) {
    dynamic itemsData = json['data'] ?? json['items'] ?? json['results'] ?? json;

    if (itemsData is Map<String, dynamic>) {
      itemsData = itemsData['content'] ?? itemsData['items'] ?? itemsData['results'];
    }

    final List<T> items;
    if (itemsData is List) {
      items = itemsData
          .map((item) => itemFromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      items = [];
    }

    final metadataSource = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final int page = _extractInt(metadataSource, ['pageNo', 'current_page', 'currentPage'], 0);
    final int totalPages = _extractInt(
      metadataSource,
      ['total_page', 'total_pages', 'totalPages', 'page_count'],
      1,
    );
    final int totalItems = _extractInt(
      metadataSource,
      ['totalCount', 'total_count', 'total_result', 'total_items', 'totalResult', 'totalItems', 'total', 'count'],
      items.length,
    );

    final bool hasMore = items.length == pageSize;

    return PaginationResponse(
      items: items,
      currentPage: page,
      totalPages: totalPages,
      totalItems: totalItems,
      hasMore: hasMore,
    );
  }

  static int _extractInt(
    Map<String, dynamic> json,
    List<String> possibleKeys,
    int defaultValue,
  ) {
    for (final key in possibleKeys) {
      final value = json[key];
      if (value != null) {
        if (value is int) return value;
        if (value is String) return int.tryParse(value) ?? defaultValue;
        if (value is double) return value.toInt();
      }
    }
    return defaultValue;
  }

  PaginationResponse<T> copyWith({
    List<T>? items,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    bool? hasMore,
    String? nextPageToken,
  }) {
    return PaginationResponse(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

sealed class PaginationError implements Exception {
  final String message;

  const PaginationError(this.message);

  @override
  String toString() => message;

  factory PaginationError.network([String? message]) = NetworkPaginationError;

  factory PaginationError.server([String? message]) = ServerPaginationError;

  factory PaginationError.timeout([String? message]) = TimeoutPaginationError;

  factory PaginationError.parsing([String? message]) = ParsingPaginationError;

  factory PaginationError.unknown([String? message]) = UnknownPaginationError;
}

class NetworkPaginationError extends PaginationError {
  const NetworkPaginationError([String? message])
      : super(message ?? 'No internet connection. Please check your network.');
}

class ServerPaginationError extends PaginationError {
  const ServerPaginationError([String? message])
      : super(message ?? 'Server error occurred. Please try again later.');
}

class TimeoutPaginationError extends PaginationError {
  const TimeoutPaginationError([String? message])
      : super(message ?? 'Request timed out. Please try again.');
}

class ParsingPaginationError extends PaginationError {
  const ParsingPaginationError([String? message])
      : super(message ?? 'Failed to parse response data.');
}

class UnknownPaginationError extends PaginationError {
  const UnknownPaginationError([String? message])
      : super(message ?? 'An unexpected error occurred.');
}
