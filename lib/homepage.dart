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
  final searchController = TextEditingController();
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
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                validator: (todo) => todo == null || todo.isEmpty ? '!!' : null,
                controller: todoController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: InputBorder.none,
                  hintText: "ToDo",
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: labelController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: InputBorder.none,
                  hintText: "Label",
                ),
              ),
            ],
          ),
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
          addTodo(todoctrl.text);
          todoctrl.text = '';
          Navigator.of(context).pop();
        }
      },
      child: Text("Add"),
    );
  }

  Widget buildBody(List<Todo> todos) {
    todos.sort((a, b) => (b.isTicked ? 0 : 1) - (a.isTicked ? 0 : 1));
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30,),
          Container(
            width: 500,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blue, 
                width: 2, 
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8),
              child: TextField(
                decoration: InputDecoration(hintText: "Search",border: InputBorder.none,),
              ),
            ),
          ),
          SizedBox(height: 30,),
          Expanded(
            child: SizedBox(
              width: 700,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: todos.length,
                padding: EdgeInsets.all(12),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.grey.shade300,borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisSize: MainAxisSize.min,
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
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                  ),
                                ),
                                SizedBox(
                                  width: 580,
                                  child: Text(
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                    maxLines: null,
                                    todos[index].todo,
                                    style: TextStyle(
                                      decoration:
                                          todos[index].isTicked
                                              ? TextDecoration.lineThrough
                                              : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                              
                            IconButton(
                              onPressed: () {
                                deleteTodo(todos[index]);
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
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
