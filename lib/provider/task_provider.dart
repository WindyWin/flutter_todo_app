import 'package:flutter/material.dart';
import 'package:todo_app/data/models/task.dart';
import 'package:todo_app/data/service/task_service.dart';

class TaskProvider extends ChangeNotifier {
  bool isLoading = true;
  List<Task> tasks = [];
  final TaskService _taskService = TaskService();

  addTask(Task task) async {
    isLoading = true;
    notifyListeners();
    await _taskService.insert(task);
    isLoading = false;
    notifyListeners();
  }

  getTasks() async {
    isLoading = true;
    notifyListeners();
    tasks = await _taskService.getTasks();
    tasks.sort((a, b) => a.isDone! ? 1 : -1);
    isLoading = false;
    notifyListeners();
  }

  getTask(int id) async {
    isLoading = true;
    notifyListeners();
    var task = await _taskService.getTask(id);
    isLoading = false;
    notifyListeners();
    return task;
  }

  updateTask(Task task) async {
    isLoading = true;
    notifyListeners();
    await _taskService.update(task);
    isLoading = false;
    notifyListeners();
  }

  deleteTask(int id) async {
    await _taskService.delete(id);
    notifyListeners();
  }

  toggleDoneTask(Task task) async {
    task.isDone = !task.isDone!;
    await _taskService.update(task);
  }

  @override
  void dispose() {
    super.dispose();
    _taskService.close();
  }
}
