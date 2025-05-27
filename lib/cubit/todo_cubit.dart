import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/model/todosclass.dart';
import 'package:todo/box/boxes.dart';

class TodoCubit extends Cubit<List<Todo>> {
  TodoCubit() : super([Todo()]) {
    emit(Boxes.getTodos().values.toList().cast<Todo>());
  }

  void addTodo({required todoctrl, required label}) {
    final todo =
        Todo()
          ..todo = todoctrl
          ..isTicked = false
          ..labels = label;
    final box = Boxes.getTodos();
    box.add(todo);
    emit([...state, todo]);
  }

  void deleteTodo({required Todo todo}) {
    todo.delete();
    emit(Boxes.getTodos().values.toList().cast<Todo>());
  }

  void updateTodo({required Todo todo}) {
    todo.isTicked = !todo.isTicked;
    todo.save();
    emit(Boxes.getTodos().values.toList().cast<Todo>());
  }
}
