import 'package:flutter/material.dart';
import 'package:lista/repositories/todo_repository.dart';
import 'package:lista/widgets/todo_item.dart';
import 'package:lista/models/todo.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todocontroller = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();
  List<Todo> todos = [];
  Todo? deletedTodo;
  int? deletedTodoPos;

  String? errorText;

  @override
  void initState() {
    super.initState();

    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 0.0,
                          maxWidth: 300,
                          minHeight: 0.0,
                          maxHeight: 60,
                        ),
                        child: TextField(
                          controller: todocontroller,
                          decoration: InputDecoration(
                            labelText: 'Adicione uma tarefa',
                            hintText: 'Ex: Estudar',
                            errorText: errorText,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          String text = todocontroller.text;

                          if (text.isEmpty) {
                            errorText = 'Tarefa não inserida';
                            return;
                          }

                          setState(() {
                            Todo newTodo =
                                Todo(title: text, dateTime: DateTime.now());
                            todos.add(newTodo);
                          });
                          todocontroller.clear();
                          todoRepository.saveList(todos);
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(1)),
                        child: const Icon(Icons.add_rounded, size: 60),
                      ),
                    ]),
                Flexible(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 400),
                    child: ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(16),
                        children: [
                          for (Todo todo in todos)
                            TodoItem(
                              todo: todo,
                              delete: delete,
                            ),
                        ]),
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                          width: 200,
                          child: Column(
                            children: [
                              Text(
                                "${todos.length}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 50,
                                ),
                              ),
                              const Text(
                                "Tarefas Pendentes",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30),
                              )
                            ],
                          )),
                      ElevatedButton.icon(
                        label: const SizedBox(
                          width: 80,
                          child: Text(
                            "Limpar tudo",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ),
                        onPressed: () {
                          deleteDialog();
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.all(1)),
                        icon: const Icon(Icons.delete_sweep_rounded, size: 60),
                      ),
                    ]),
              ]),
        ),
      ),
    );
  }

  void delete(Todo todo) {
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);
    setState(() {
      todos.remove(todo);
    });
    todoRepository.saveList(todos);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Tarefa ${todo.title} foi removida'),
      action: SnackBarAction(
          onPressed: () {
            setState(() {
              todos.insert(deletedTodoPos!, deletedTodo!);
            });
            todoRepository.saveList(todos);
          },
          label: 'Desfazer'),
    ));
  }

  void deleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar tudo?'),
        content: const Text('Tem certeza que deseja apagar todas as tarefas?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                todos.clear();
              });
              todoRepository.saveList(todos);
            },
            style: TextButton.styleFrom(primary: Colors.red),
            child: const Text("Limpar tudo"),
          )
        ],
      ),
    );
  }
}
