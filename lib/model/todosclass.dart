import 'package:hive/hive.dart';

part 'todosclass.g.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  late String todo;

  @HiveField(1)
  late bool isTicked;

  @HiveField(2)
  late String labels;
}