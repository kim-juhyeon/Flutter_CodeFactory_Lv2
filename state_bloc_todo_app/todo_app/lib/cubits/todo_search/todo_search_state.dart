part of 'todo_search_cubit.dart';

sealed class TodoSearchState extends Equatable {
  const TodoSearchState();

  @override
  List<Object> get props => [];
}

final class TodoSearchInitial extends TodoSearchState {}
