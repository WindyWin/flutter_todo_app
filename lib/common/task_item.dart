import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/edit_task_dialog.dart';
import 'package:todo_app/data/models/task.dart';
import 'package:todo_app/provider/task_provider.dart';
import 'package:todo_app/views/task_view.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            // offset: const Offset(0, 1),
            // blurRadius: 6.0,
          )
        ],
      ),
      child: ListTile(
        enabled: !task.isDone!,
        title: Text(
          "${task.title!}${task.isDone! ? " (Done)" : ""}",
          style: TextStyle(
              decoration: task.isDone!
                  ? TextDecoration.lineThrough
                  : TextDecoration.none),
        ),
        subtitle:
            //  Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // children: [
            Text(task.content!),
        // Text(task.createAt!.toLocal().toString())
        // ],
        // ),
        trailing: PopupMenuButton<TaskAction>(
          onSelected: (taskAction) {
            taskAction.onPressed();
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<TaskAction>>[
            PopupMenuItem<TaskAction>(
              value: TaskAction(
                  onPressed: () {
                    context
                        .read<TaskProvider>()
                        .updateTask(task..isDone = !task.isDone!);
                    context.read<TaskProvider>().getTasks();
                  },
                  title: 'Mark as completed'),
              child: Text(
                  'Mark as ${task.isDone! ? "uncompleted" : "completed"}',
                  style: const TextStyle(color: Colors.green)),
            ),
            PopupMenuItem<TaskAction>(
              value: TaskAction(
                  onPressed: () {
                    final formKey = GlobalKey<FormState>();
                    showDialog(
                        context: context,
                        builder: (_) {
                          return EditForm(
                              formKey: formKey, context: _, task: task);
                        });
                  },
                  title: 'Update'),
              child:
                  const Text('Update', style: TextStyle(color: Colors.yellow)),
            ),
            PopupMenuItem<TaskAction>(
              value: TaskAction(
                  onPressed: () {
                    context.read<TaskProvider>().deleteTask(task.id!);
                    context.read<TaskProvider>().getTasks();
                  },
                  title: 'Remove'),
              child: const Text('Remove', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}
