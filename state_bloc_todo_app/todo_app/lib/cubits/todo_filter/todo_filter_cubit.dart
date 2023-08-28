import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_app/models/todo_model.dart';

part 'todo_filter_state.dart';

class TodoFilterCubit extends Cubit<TodoFilterState> {
  TodoFilterCubit() : super(TodoFilterState.initial());

  void changeFilter(Filter newFilter) {
    emit(
      state.copyWith(filter: newFilter),
    ); //사용자가 filterapp을 탭할때마다 todofilterstate가 변경되는 코드를 작성합니다.
  }
}
