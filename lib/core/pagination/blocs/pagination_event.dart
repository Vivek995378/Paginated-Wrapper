import 'package:equatable/equatable.dart';

sealed class PaginationEvent extends Equatable {
  const PaginationEvent();

  @override
  List<Object?> get props => [];
}

class LoadPage extends PaginationEvent {
  final int page;

  const LoadPage({required this.page});

  @override
  List<Object?> get props => [page];
}

class LoadMore extends PaginationEvent {
  const LoadMore();
}

class Retry extends PaginationEvent {
  const Retry();
}

class LoadInitial extends PaginationEvent {
  const LoadInitial();
}