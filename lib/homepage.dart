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
      contentPadding: const EdgeInsets.only(top: 20, left: 20),
      // backgroundColor: Colors.grey.shade900,
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
              // decoration: InputDecoration(
              //     filled: true,
              //     fillColor: Colors.grey.shade900,
              //     border: InputBorder.none,
              //     contentPadding: const EdgeInsets.only(
              //         left: 15, bottom: 16, top: 75, right: 18),
              //     hintText: "Amount",
              //     hintStyle: const TextStyle(color: Colors.white70)),
              // style: const TextStyle(fontSize: 50, color: Colors.white70),
              // cursorColor: Colors.white70,
              // cursorHeight: 62,
              // textAlign: TextAlign.end,
            ),
            TextFormField(
              // validator: (todo) => todo != null ? '!!' : null,
              controller: labelController,
              // decoration: InputDecoration(
              //     filled: true,
              //     fillColor: Colors.grey.shade900,
              //     border: InputBorder.none,
              //     contentPadding: const EdgeInsets.only(
              //         left: 15, bottom: 16, top: 75, right: 18),
              //     hintText: "Amount",
              //     hintStyle: const TextStyle(color: Colors.white70)),
              // style: const TextStyle(fontSize: 50, color: Colors.white70),
              // cursorColor: Colors.white70,
              // cursorHeight: 62,
              // textAlign: TextAlign.end,
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
              },
              icon: Icon(
                todos[index].isTicked
                    ? Icons.square_sharp
                    : Icons.square_outlined,
              ),
            ),
            Text(todos[index].todo, style: TextStyle()),
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
