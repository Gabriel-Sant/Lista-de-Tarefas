import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoItem extends StatelessWidget {
  const TodoItem({
    Key? key,
    required this.todo,
    required this.delete,
  }) : super(key: key);

  final Todo todo;
  final Function(Todo) delete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Slidable(
        closeOnScroll: true,
        endActionPane: ActionPane(
          extentRatio: 0.21,
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              spacing: 8,
              borderRadius: BorderRadius.circular(16),
              onPressed: ((context) {
                delete(todo);
              }),
              backgroundColor: Colors.red,
              icon: Icons.delete_forever_rounded,
              label: ("Deletar"),
            ),
          ],
        ),
        child: ListTile(
          tileColor: Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            todo.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            DateFormat("dd/MM/yyyy - HH:mm").format(DateTime.now()),
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
