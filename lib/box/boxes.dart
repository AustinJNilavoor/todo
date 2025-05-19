import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/model/todosclass.dart';

class Boxes {
  static Box<Todo> getTodos() =>
      Hive.box<Todo>('todos');
  }