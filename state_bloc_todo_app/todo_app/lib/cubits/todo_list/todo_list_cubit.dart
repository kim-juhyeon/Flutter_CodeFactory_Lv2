import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'todo_list_state.dart';

class TodoListCubit extends Cubit<TodoListState> {
  TodoListCubit() : super(TodoListInitial());
}
