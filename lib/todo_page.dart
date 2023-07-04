import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final List<Todo> todoList = [];

  final todoTitle = TextEditingController();
  final todoStatus = TextEditingController();
  final keys = GlobalKey<FormState>();

  late SharedPreferences prefs;
  @override
  void initState() {
    initializePref();
    super.initState();
  }

  void initializePref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      final List<String>? items = prefs.getStringList('items');
      if (items != null) {
        todoList.clear();
        for (String item in items) {
          List<String> parts = item.split("|");
          if (parts.length == 2) {
            todoList.add(Todo(parts[0], parts[1]));
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        child: ListView.builder(
          itemBuilder: (context, index) {
            Todo todo = todoList[index];
            return ListTile(
              title: Text(todo.title),
              subtitle: Text(todo.status),
            );
          },
          itemCount: todoList.length,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addTodo(context);
        },
        child: const Text("+"),
      ),
    );
  }

  addTodo(BuildContext context) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(45.0),
        ),
      ),
      isScrollControlled: true,
      context: context,
      builder: ((context) {
        return SizedBox(
          height: 500,
          child: Padding(
            padding: EdgeInsets.only(
              top: 20,
              right: 20,
              left: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Form(
              key: keys,
              child: Column(
                children: [
                  TextFormField(
                    style: const TextStyle(),
                    controller: todoTitle,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      ),
                      hintText: ("Todo"),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    style: const TextStyle(),
                    controller: todoStatus,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      ),
                      hintText: ("Status"),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (keys.currentState!.validate()) {
                        setState(() {
                          todoList.add(Todo(todoTitle.text, todoStatus.text));
                        });
                        List<String> todoItems = todoList
                            .map((todo) => "${todo.title}|${todo.status}")
                            .toList();
                        prefs.setStringList('items', todoItems);

                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Save"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Remove data for the 'counter' key.
                      setState(() {
                        todoList.clear();
                      });
                      await prefs.remove('items');
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    },
                    child: const Text("Clear all"),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class Todo {
  String title;
  String status;

  Todo(
    this.title,
    this.status,
  );
}
