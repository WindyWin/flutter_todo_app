import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/add_task_dialog.dart';
import 'package:todo_app/common/task_item.dart';
import 'package:todo_app/data/models/task.dart';
import 'package:todo_app/data/service/task_service.dart';
import 'package:todo_app/provider/task_provider.dart';
import 'package:todo_app/provider/theme_provider.dart';

class TaskView extends StatefulWidget {
  const TaskView({super.key});

  @override
  State<TaskView> createState() => _TaskViewState();
}

class TaskAction {
  TaskAction({required this.title, required this.onPressed});

  final String title;
  final Function() onPressed;
}

class _TaskViewState extends State<TaskView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await TaskService.open();
      await Provider.of<TaskProvider>(context, listen: false).getTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Todo App'),
          actions: [
            Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
              final icon = themeProvider.mode == ThemeMode.light
                  ? const Icon(Icons.light_mode)
                  : Icon(
                      Icons.dark_mode,
                      color: Theme.of(context).colorScheme.primary,
                    );

              return Switch(
                  thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
                      (Set<MaterialState> states) {
                    return icon; // All other states will use the default thumbIcon.
                  }),
                  value: themeProvider.mode == ThemeMode.dark,
                  onChanged: (value) {
                    themeProvider.changeThemeMode(
                        value ? ThemeMode.dark : ThemeMode.light);
                  });
            }),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () =>
              Provider.of<TaskProvider>(context, listen: false).getTasks(),
          child: Consumer<TaskProvider>(
            builder: (context, value, child) {
              if (value.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              final List<Task> tasks = value.tasks;

              if (tasks.isEmpty) return const Center(child: Text('No Tasks'));

              return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final Task task = tasks[index];
                  return TaskItem(task: task);
                },
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final formKey = GlobalKey<FormState>();
            showDialog(
                context: context,
                builder: (_) {
                  return AddForm(formKey: formKey, context: _);
                });
          },
          child: const Icon(Icons.add),
        ));
  }
}
