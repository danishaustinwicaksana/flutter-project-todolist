
import 'package:flutter/material.dart';
import 'task.dart';
import 'task_item.dart';
import 'search_item.dart' as custom;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TaskScreen(),
    );
  }
}

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<Task> tasks = [];
  List<Task> filteredTasks = [];
  bool isFiltered = false;

  void _addOrUpdateTask({Task? task}) {
    TextEditingController titleController = TextEditingController(text: task?.title);
    TextEditingController descController = TextEditingController(text: task?.description);
    bool isEditing = task != null;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEditing ? 'Edit Task' : 'New Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: InputDecoration(labelText: 'Title')),
            TextField(controller: descController, decoration: InputDecoration(labelText: 'Description')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (isEditing) {
                  task.title = titleController.text;
                  task.description = descController.text;
                } else {
                  tasks.add(Task(
                    id: DateTime.now().toString(),
                    title: titleController.text,
                    description: descController.text,
                  ));
                }
              });
              Navigator.of(ctx).pop();
            },
            child: Text(isEditing ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  void _deleteTask(String id) {
    setState(() {
      tasks.removeWhere((task) => task.id == id);
      filteredTasks.removeWhere((task) => task.id == id);
    });
  }

  void _filterTasks(String query) {
    setState(() {
      filteredTasks = tasks
          .where((task) => task.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
      isFiltered = query.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('To-Do List')),
      body: Column(
        children: [
          custom.SearchBar(tasks: tasks, onSearch: _filterTasks),
          Expanded(child: ListView.builder(
            itemCount: isFiltered? filteredTasks.length : tasks.length,
            itemBuilder: (ctx, index) {
              return TaskItem(task: isFiltered? filteredTasks[index] : tasks[index], onEdit: _addOrUpdateTask, onDelete: _deleteTask);
            },
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _addOrUpdateTask(),
      ),
    );
  }
}



