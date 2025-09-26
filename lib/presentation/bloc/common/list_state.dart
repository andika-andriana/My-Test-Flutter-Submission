import 'package:ditonton_core/ditonton_core.dart';
import 'package:equatable/equatable.dart';

class ListState<T> extends Equatable {
  const ListState({
    this.status = RequestState.empty,
    this.items = const [],
    this.message = '',
  });

  final RequestState status;
  final List<T> items;
  final String message;

  ListState<T> copyWith({
    RequestState? status,
    List<T>? items,
    String? message,
  }) {
    return ListState<T>(
      status: status ?? this.status,
      items: items ?? this.items,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, items, message];
}
