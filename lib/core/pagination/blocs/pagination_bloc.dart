import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/pagination_models.dart';
import 'pagination_event.dart';
import 'pagination_state.dart';

typedef PageFetcher<T extends PaginatedItem> = Future<PaginationResponse<T>>
    Function({
  required String endpoint,
  required int page,
  required int pageSize,
  Map<String, dynamic>? queryParams,
  Map<String, String>? headers,
});

class PaginationBloc<T extends PaginatedItem>
    extends Bloc<PaginationEvent, PaginationState<T>> {
  final PageFetcher<T> fetchPage;
  final String endpoint;
  final PaginationConfig config;
  final Map<String, String>? headers;

  PaginationBloc({
    required this.fetchPage,
    required this.endpoint,
    PaginationConfig? config,
    this.headers,
  })  : config = config ?? const PaginationConfig(),
        super(PaginationState<T>.initial()) {
    on<LoadPage>(_onLoadPage);
    on<LoadMore>(_onLoadMore);
    on<Retry>(_onRetry);
    on<LoadInitial>(_onLoadInitial);
  }

  Future<void> _onLoadPage(
    LoadPage event,
    Emitter<PaginationState<T>> emit,
  ) async {
    emit(state.toLoading());

    try {
      final response = await fetchPage(
        endpoint: endpoint,
        page: event.page,
        pageSize: config.pageSize,
        headers: headers,
      );

      emit(state.toSuccess(
        items: response.items,
        currentPage: event.page,
        totalPages: response.totalPages,
        totalItems: response.totalItems,
        hasMore: response.hasMore,
      ));
    } on PaginationError catch (error) {
      emit(state.toError(error));
    } catch (error) {
      emit(state.toError(PaginationError.unknown(error.toString())));
    }
  }

  Future<void> _onLoadMore(
    LoadMore event,
    Emitter<PaginationState<T>> emit,
  ) async {
    if (state.isAnyLoading || !state.hasMore) return;

    emit(state.toLoadingMore());

    try {
      final nextPage = state.currentPage + 1;

      final response = await fetchPage(
        endpoint: endpoint,
        page: nextPage,
        pageSize: config.pageSize,
        headers: headers,
      );

      final allItems = [...state.items, ...response.items];

      emit(state.toSuccess(
        items: allItems,
        currentPage: nextPage,
        totalPages: response.totalPages,
        totalItems: response.totalItems,
        hasMore: response.hasMore,
      ));
    } on PaginationError catch (error) {
      emit(state.toError(error));
    } catch (error) {
      emit(state.toError(PaginationError.unknown(error.toString())));
    }
  }

  Future<void> _onRetry(
    Retry event,
    Emitter<PaginationState<T>> emit,
  ) async {
    if (state.isEmpty) {
      add(LoadPage(page: config.initialPage));
    } else {
      add(const LoadMore());
    }
  }

  Future<void> _onLoadInitial(
    LoadInitial event,
    Emitter<PaginationState<T>> emit,
  ) async {
    emit(PaginationState<T>.initial());
    add(LoadPage(page: config.initialPage));
  }
}
