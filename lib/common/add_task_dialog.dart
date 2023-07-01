import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/data/models/task.dart';

import '../provider/task_provider.dart';

class AddForm extends StatefulWidget {
  const AddForm({
    super.key,
    required this.formKey,
    required this.context,
  });

  final GlobalKey<FormState> formKey;
  final BuildContext context;

  @override
  State<AddForm> createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  String _title = "";
  String _content = "";
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
              await context.read<TaskProvider>().addTask(
                    Task(
                      title: _title,
                      content: _content,
                      createAt: DateTime.now(),
                      isDone: false,
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
