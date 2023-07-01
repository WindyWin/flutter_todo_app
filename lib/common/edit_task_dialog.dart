import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/data/models/task.dart';

import '../provider/task_provider.dart';

class EditForm extends StatefulWidget {
  const EditForm({
    super.key,
    required this.formKey,
    required this.context,
    required this.task,
  });

  final GlobalKey<FormState> formKey;
  final BuildContext context;
  final Task task;

  @override
  State<EditForm> createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
  String _title = "";
  String _content = "";
  bool _isDone = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _title = widget.task.title ?? "";
    _content = widget.task.content ?? "";
    _isDone = widget.task.isDone!;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: AlertDialog(
        title: const Text('Add Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: widget.task.title,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onChanged: (value) => setState(() => _title = value),
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: widget.task.content,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }

                return null;
              },
              onChanged: (value) => setState(() => _content = value),
              decoration: const InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            CheckboxListTile(
              title: const Text('Is Done'),
              value: _isDone,
              onChanged: (value) => setState(() => _isDone = value!),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(widget.context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (!widget.formKey.currentState!.validate()) return;

              await context.read<TaskProvider>().updateTask(
                    Task(
                      id: widget.task.id,
                      title: _title,
                      content: _content,
                      createAt: DateTime.now(),
                      isDone: _isDone,
                    ),
                  );
              context.read<TaskProvider>().getTasks();
              Navigator.pop(widget.context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
