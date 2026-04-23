import 'package:equatable/equatable.dart';
import '../models/pagination_models.dart';

enum PaginationStatus {
  initial,
  loading,
  success,
  loadingMore,
  error,
  refreshing,
  endReached,
}

class PaginationState<T extends PaginatedItem> extends Equatable {
  final PaginationStatus status;
  final List<T> items;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final bool hasMore;
  final PaginationError? error;

  const PaginationState({
    required this.status,
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.hasMore,
    this.error,
  });

  factory PaginationState.initial() {
    return PaginationState<T>(
      status: PaginationStatus.initial,
      items: const [],
      currentPage: 0,
      totalPages: 0,
      totalItems: 0,
      hasMore: true,
      error: null,
    );
  }

  PaginationState<T> toLoading() => copyWith(status: PaginationStatus.loading, error: null);
  PaginationState<T> toLoadingMore() => copyWith(status: PaginationStatus.loadingMore, error: null);
  PaginationState<T> toRefreshing() => copyWith(status: PaginationStatus.refreshing, error: null);

  PaginationState<T> toSuccess({
    required List<T> items,
    required int currentPage,
    required int totalPages,
    required int totalItems,
    required bool hasMore,
  }) {
    return copyWith(
      status: hasMore ? PaginationStatus.success : PaginationStatus.endReached,
      items: items,
      currentPage: currentPage,
      totalPages: totalPages,
      totalItems: totalItems,
      hasMore: hasMore,
      error: null,
    );
  }

  PaginationState<T> toError(PaginationError error) => copyWith(status: PaginationStatus.error, error: error);
  PaginationState<T> toEndReached() => copyWith(status: PaginationStatus.endReached, hasMore: false);

  bool get isInitial => status == PaginationStatus.initial;
  bool get isLoading => status == PaginationStatus.loading;
  bool get isSuccess => status == PaginationStatus.success;
  bool get isLoadingMore => status == PaginationStatus.loadingMore;
  bool get isError => status == PaginationStatus.error;
  bool get isRefreshing => status == PaginationStatus.refreshing;
  bool get isEndReached => status == PaginationStatus.endReached;
  bool get isAnyLoading => isLoading || isLoadingMore || isRefreshing;
  bool get isEmpty => items.isEmpty;
  bool get hasItems => items.isNotEmpty;
  bool get canLoadMore => hasMore && !isAnyLoading && !isError;
  bool get isFirstPage => currentPage <= 1;

  @override
  List<Object?> get props => [status, items, currentPage, totalPages, totalItems, hasMore, error];

  PaginationState<T> copyWith({
    PaginationStatus? status,
    List<T>? items,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    bool? hasMore,
    PaginationError? error,
  }) {
    return PaginationState<T>(
      status: status ?? this.status,
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      hasMore: hasMore ?? this.hasMore,
      error: error ?? this.error,
    );
  }
}