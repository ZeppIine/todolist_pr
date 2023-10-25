// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoListApp(),
    );
  }
}

class TodoListApp extends StatefulWidget {
  const TodoListApp({super.key});

  @override
  _TodoListAppState createState() => _TodoListAppState();
}

class _TodoListAppState extends State<TodoListApp> {
  final List<TodoItem> _todoList = [];
  bool _showCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          IconButton(
            icon: Icon(_showCompleted
                ? Icons.check_box
                : Icons.check_box_outline_blank),
            onPressed: () {
              setState(() {
                _showCompleted = !_showCompleted;
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _todoList.length,
        itemBuilder: (context, index) {
          if (_showCompleted && !_todoList[index].isComplete) {
            return const SizedBox.shrink(); // 체크된 항목을 보이지 않게 함
          }
          return TodoItemWidget(
            todoItem: _todoList[index],
            onDelete: () {
              setState(() {
                _todoList.removeAt(index);
              });
            },
            onToggleComplete: (value) {
              setState(() {
                _todoList[index].isComplete = value!;
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              String newTodo = '';
              return AlertDialog(
                title: const Text('할 일 추가'),
                content: TextField(
                  autofocus: true,
                  decoration: const InputDecoration(labelText: '할 일을 입력하세요'),
                  onChanged: (value) {
                    newTodo = value;
                  },
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('취소'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (newTodo.isNotEmpty) {
                        setState(() {
                          _todoList.add(TodoItem(title: newTodo));
                        });
                      }
                      Navigator.of(context).pop();
                    },
                    child: const Text('등록'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TodoItem {
  String title;
  bool isComplete;

  TodoItem({required this.title, this.isComplete = false});
}

class TodoItemWidget extends StatelessWidget {
  final TodoItem todoItem;
  final VoidCallback onDelete;
  final ValueChanged<bool?> onToggleComplete;

  const TodoItemWidget({
    super.key,
    required this.todoItem,
    required this.onDelete,
    required this.onToggleComplete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: todoItem.isComplete,
        onChanged: onToggleComplete,
      ),
      title: Text(
        todoItem.title,
        style: todoItem.isComplete
            ? const TextStyle(decoration: TextDecoration.lineThrough)
            : null,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: onDelete,
      ),
    );
  }
}
