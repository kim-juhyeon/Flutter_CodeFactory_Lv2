part of 'todo_filter_cubit.dart';

sealed class TodoFilterState extends Equatable {
  const TodoFilterState();

  @override
  List<Object> get props => [];
}

final class TodoFilterInitial extends TodoFilterState {}
