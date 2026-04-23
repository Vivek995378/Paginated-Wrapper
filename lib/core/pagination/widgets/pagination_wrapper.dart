import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/pagination_bloc.dart';
import '../blocs/pagination_event.dart';
import '../blocs/pagination_state.dart';
import '../models/pagination_models.dart';
import 'common_pagination_widgets.dart';

class PaginationWrapper<T extends PaginatedItem> extends StatefulWidget {
  final PaginationBloc<T> bloc;

  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  final Widget? emptyWidget;

  final Widget? loadingWidget;

  final Widget Function(BuildContext context, PaginationError error)?
      errorWidget;

  final Widget? loadMoreWidget;

  final double loadMoreThreshold;

  final EdgeInsetsGeometry? padding;

  final Widget Function(BuildContext context, int index)? separatorBuilder;

  final ScrollPhysics? physics;

  final bool shrinkWrap;

  final ScrollController? scrollController;

  final void Function(T item, int index)? onItemTap;

  final bool showLoadMoreIndicator;

  final Color? refreshIndicatorColor;

  const PaginationWrapper({
    super.key,
    required this.bloc,
    required this.itemBuilder,
    this.emptyWidget,
    this.loadingWidget,
    this.errorWidget,
    this.loadMoreWidget,
    this.loadMoreThreshold = 0.6,
    this.padding,
    this.separatorBuilder,
    this.physics,
    this.shrinkWrap = false,
    this.scrollController,
    this.onItemTap,
    this.showLoadMoreIndicator = true,
    this.refreshIndicatorColor,
  });

  @override
  State<PaginationWrapper<T>> createState() =>
      _PaginationWrapperState<T>();
}

class _PaginationWrapperState<T extends PaginatedItem>
    extends State<PaginationWrapper<T>> {
  late ScrollController _scrollController;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    _scrollController.addListener(_onScroll);

    if (widget.bloc.state.isInitial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.bloc.add(const LoadInitial());
      });
    }
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    } else {
      _scrollController.removeListener(_onScroll);
    }
    super.dispose();
  }

  void _onScroll() {
    if (_isLoadingMore) return;
    
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    
    if (maxScroll == 0) {
      final state = widget.bloc.state;
      if (state.canLoadMore && !_isLoadingMore) {
        _isLoadingMore = true;
        widget.bloc.add(const LoadMore());
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _isLoadingMore = false;
          }
        });
      }
      return;
    }
    
    final threshold = maxScroll * widget.loadMoreThreshold;

    if (currentScroll >= threshold) {
      final state = widget.bloc.state;
      if (state.canLoadMore) {
        _isLoadingMore = true;
        widget.bloc.add(const LoadMore());
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _isLoadingMore = false;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaginationBloc<T>, PaginationState<T>>(
      bloc: widget.bloc,
      builder: (context, state) {
        if (state.isLoading && state.isEmpty) {
          return widget.loadingWidget ??
              CommonPaginationWidgets.buildLoadingIndicator();
        }

        if (state.isError && state.isEmpty) {
          return widget.errorWidget?.call(context, state.error!) ??
              CommonPaginationWidgets.buildErrorWidget(
                error: state.error!,
                onRetry: () => widget.bloc.add(const Retry()),
              );
        }

        return _buildListView(context, state);
      },
    );
  }

  Widget _buildListView(BuildContext context, PaginationState<T> state) {
    final itemCount = state.items.length + (state.isLoadingMore ? 1 : 0);

    Widget listView;

    if (widget.separatorBuilder != null) {
      listView = ListView.separated(
        controller: _scrollController,
        padding: widget.padding,
        physics: widget.physics,
        shrinkWrap: widget.shrinkWrap,
        itemCount: itemCount,
        separatorBuilder: widget.separatorBuilder!,
        itemBuilder: (context, index) => _buildItem(context, state, index),
      );
    } else {
      listView = ListView.builder(
        controller: _scrollController,
        padding: widget.padding,
        physics: widget.physics,
        shrinkWrap: widget.shrinkWrap,
        itemCount: itemCount,
        itemBuilder: (context, index) => _buildItem(context, state, index),
      );
    }

    return listView;
  }

  Widget _buildItem(BuildContext context, PaginationState<T> state, int index) {
    if (index >= state.items.length) {
      if (widget.showLoadMoreIndicator) {
        return widget.loadMoreWidget ??
            CommonPaginationWidgets.buildLoadMoreIndicator();
      }
      return const SizedBox.shrink();
    }

    final item = state.items[index];

    if (widget.onItemTap != null) {
      return InkWell(
        onTap: () => widget.onItemTap!(item, index),
        child: widget.itemBuilder(context, item, index),
      );
    }

    return widget.itemBuilder(context, item, index);
  }
}
