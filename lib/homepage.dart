import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/box/boxes.dart';
import 'package:todo/model/todosclass.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final todoController = TextEditingController();
  final labelController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    todoController.dispose();
    labelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<Box<Todo>>(
        valueListenable: Boxes.getTodos().listenable(),
        builder: (context, box, _) {
          final transactions = box.values.toList().cast<Todo>();
          return buildBody(transactions);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (context) => addDialog());
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget addDialog() {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      title: const Text('Add ToDo'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              validator: (todo) => todo == null || todo.isEmpty ? '!!' : null,
              controller: todoController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.lightBlue.shade100,
                border: InputBorder.none,
                hintText: "ToDo",
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: labelController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.lightBlue.shade100,
                border: InputBorder.none,
                hintText: "Label",
              ),
            ),
          ],
        ),
      ),
      actions: [addButton(context, todoController)],
    );
  }

  Widget addButton(context, TextEditingController todoctrl) {
    return TextButton(
      onPressed: () {
        final isValid = formKey.currentState!.validate();
        if (isValid) {
          print(todoctrl.text);
          addTodo(todoctrl.text);
          todoctrl.text = '';
          Navigator.of(context).pop();
        }
      },
      child: Text("Add"),
    );
  }

  Widget buildBody(List<Todo> todos) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: todos.length,
      padding: EdgeInsets.all(12),
      itemBuilder: (context, index) {
        return Row(
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  todos[index].isTicked = !todos[index].isTicked;
                });
                todos[index].save();
              },
              icon: Icon(
                todos[index].isTicked
                    ? Icons.square_sharp
                    : Icons.square_outlined,
              ),
            ),
            Text(
              todos[index].todo,
              style: TextStyle(
                decoration:
                    todos[index].isTicked ? TextDecoration.lineThrough : null,
              ),
            ),
            IconButton(
              onPressed: () {
                deleteTodo(todos[index]);
              },
              icon: Icon(Icons.delete),
            ),
          ],
        );
      },
    );
  }

  void addTodo(todoctrl) {
    final todo =
        Todo()
          ..todo = todoctrl
          ..isTicked = false
          ..labels = "Flutter";
    final box = Boxes.getTodos();
    box.add(todo);
  }

  void deleteTodo(Todo todo) {
    todo.delete();
  }

  void editTodo(Todo todo) {}
}
