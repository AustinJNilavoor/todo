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
  String searchText = '';
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    todoController.dispose();
    labelController.dispose();
    searchController.dispose();
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
      actions: [addButton(context, todoController,labelController)],
    );
  }

  Widget addButton(context, TextEditingController todoctrl,TextEditingController labelController) {
    return TextButton(
      onPressed: () {
        final isValid = formKey.currentState!.validate();
        if (isValid) {
          addTodo(todoctrl.text,labelController.text);
          todoctrl.text = '';
          labelController.text = '';
          Navigator.of(context).pop();
        }
      },
      child: Text("Add"),
    );
  }

  Widget buildBody(List<Todo> todos) {
    final newtodos =
        searchText == ''
            ? todos
            : todos.where((todo) {
              return (todo.todo.toLowerCase().contains(
                    searchText.toLowerCase(),
                  ) ||
                  todo.labels.toLowerCase().contains(searchText.toLowerCase()));
            }).toList();
    newtodos.sort((a, b) => (b.isTicked ? 0 : 1) - (a.isTicked ? 0 : 1));
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30),
          Container(
            width: 500,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          Expanded(
            child: SizedBox(
              width: 700,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: newtodos.length,
                padding: EdgeInsets.all(12),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      newtodos[index].isTicked =
                                          !newtodos[index].isTicked;
                                    });
                                    newtodos[index].save();
                                  },
                                  icon: Icon(
                                    newtodos[index].isTicked
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
                                    newtodos[index].todo,
                                    style: TextStyle(
                                      decoration:
                                          newtodos[index].isTicked
                                              ? TextDecoration.lineThrough
                                              : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            IconButton(
                              onPressed: () {
                                deleteTodo(newtodos[index]);
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

  void addTodo(todoctrl,label) {
    final todo =
        Todo()
          ..todo = todoctrl
          ..isTicked = false
          ..labels = label;
    final box = Boxes.getTodos();
    box.add(todo);
  }

  void deleteTodo(Todo todo) {
    todo.delete();
  }

  void editTodo(Todo todo) {}
}
