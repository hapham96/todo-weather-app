import 'package:Todo_App/core/logger/logger_tracker.dart';
import 'package:Todo_App/screens/weather_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/todo.dart';

class HomeScreen extends StatelessWidget {
  final _todoBox = Hive.box<Todo>('todos');
  final _controller = TextEditingController();
  final logger = LoggerTrackerService();

  void _addTodo(String title) {
    final todo = Todo(title: title);
    _todoBox.add(todo);
    logger.logInfo("_addTodo -> $title");
    final trace = StackTrace.current.toString().split('\n');

    logger.logInfo("StackTrace -> $trace");

    // Lưu file sau này
    // Future.delayed(Duration(seconds: 3), () async {
    //   final file = await LoggerTrackerService().saveLogToFile();
    //   print("✅ Log saved to: ${file.path}");
    // });
  }

  void _toggleTodo(Todo todo) {
    todo.isDone = !todo.isDone;
    todo.save();
  }

  void _deleteTodo(int index) {
    _todoBox.deleteAt(index);
    logger.logInfo("_deleteTodo -> $index");
  }

  void _showEditDialog(BuildContext context, Todo todo) {
    final editController = TextEditingController(text: todo.title);

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Chỉnh sửa công việc'),
            content: TextField(
              controller: editController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Nhập nội dung mới...',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Huỷ'),
              ),
              ElevatedButton(
                onPressed: () {
                  final newText = editController.text.trim();
                  if (newText.isNotEmpty) {
                    todo.title = newText;
                    todo.save();
                    Navigator.pop(context);
                  }
                },
                child: Text('Lưu'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '📖 Todo App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFDEB887),
        foregroundColor: Color(0xFF3E2723),
        elevation: 1,
      ),
      body: ValueListenableBuilder(
        valueListenable: _todoBox.listenable(),
        builder: (context, Box<Todo> box, _) {
          if (box.isEmpty)
            return Center(child: Text('Chưa có công việc nào!!!'));

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final todo = box.getAt(index)!;
              return Card(
                color: Color(0xFFFFF8E1),
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Color(0xFFA1887F), width: 1),
                ),
                elevation: 2,
                child: ListTile(
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration:
                          todo.isDone ? TextDecoration.lineThrough : null,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF5D4037),
                    ),
                  ),
                  leading: Checkbox(
                    value: todo.isDone,
                    onChanged: (_) => _toggleTodo(todo),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.brown[300]),
                        onPressed: () => _showEditDialog(context, todo),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.brown[300],
                        ),
                        onPressed: () => _deleteTodo(index),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Container(
        color: Color(0xFFFAF3E0),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Ghi chép công việc...',
                  hintStyle: TextStyle(color: Colors.brown[300]),
                  filled: true,
                  fillColor: Color(0xFFFFF8E1),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFFA1887F)),
                  ),
                ),
                style: TextStyle(color: Color(0xFF5D4037)),
              ),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF5D4037),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                final text = _controller.text.trim();
                if (text.isNotEmpty) {
                  _addTodo(text);
                  _controller.clear();
                }
              },
              child: Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 20),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WeatherScreen()),
              );
            },
            backgroundColor: Color(0xFF8D6E63),
            child: Icon(Icons.cloud),
          ),
        ),
      ),
    );
  }
}
