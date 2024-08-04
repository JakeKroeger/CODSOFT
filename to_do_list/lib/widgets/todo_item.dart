import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_list/models/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ToDoItem extends StatefulWidget {
  final ToDo todo;
  final onToDoChanged;
  final onToDoDeleted;

  const ToDoItem(
      {super.key, required this.todo, this.onToDoChanged, this.onToDoDeleted});

  @override
  State<ToDoItem> createState() => _ToDoItemState();
}

class _ToDoItemState extends State<ToDoItem> {
  // Variables
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _subtaskController = TextEditingController();

  // ---------------------Save Tasks---------------------
  Future<void> _saveTasks(List<ToDo> todos) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encodedData = jsonEncode(
          todos.map((todo) => todo.toJson()).toList()); // Encode tasks
      await prefs.setString('todos', encodedData); // Save tasks
    } catch (e) {
      print('Failed to save tasks: $e');
    }
  }

// ---------------------Load Tasks---------------------
  Future<List<ToDo>> _loadTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? encodedData = prefs.getString('todos');
      if (encodedData == null) {
        return [];
      }
      final List<dynamic> decodedData = jsonDecode(encodedData);
      return decodedData
          .map((item) => ToDo.fromJson(item))
          .toList(); // Decode tasks
    } catch (e) {
      print('Failed to load tasks: $e');
      return [];
    }
  }

  // ---------------------Subtask controller---------------------
  void _handleSubtaskClick(SubTask subtask) {
    // Handle subtask click
    setState(() {
      subtask.isDone = !subtask.isDone;
      _saveTasks([widget.todo]);
    });
  }

  // ---------------------Add subtask---------------------

  void _addSubtask() {
    if (_subtaskController.text.isNotEmpty) {
      setState(() {
        widget.todo.subTasks.add(SubTask(
          subtaskText: _subtaskController.text,
          isDone: false,
        ));
        _subtaskController.clear();
        _saveTasks([widget.todo]);
      });
    }
  }

  // ---------------------Percentage of Completed Tasks----------
  double percentageOfSubtasksCompleted() {
    if (widget.todo.subTasks.isEmpty) {
      return widget.todo.isDone ? 100 : 0;
    }
    double completedSubtasks = 0;
    for (SubTask subtask in widget.todo.subTasks) {
      if (subtask.isDone) {
        completedSubtasks++;
      }
    }
    return ((completedSubtasks / widget.todo.subTasks.length) * 100);
  }

  // ---------------------Are all subtasks completed---------------------
  bool _areAllSubtasksCompleted() {
    for (SubTask subtask in widget.todo.subTasks) {
      if (!subtask.isDone) {
        return false;
      }
    }
    return true;
  }

  // ---------------------Show Edit Dialog---------------------
  void _showEditDialog() {
    _taskController.text = widget.todo.todoText!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _taskController,
                  decoration: InputDecoration(labelText: 'Task'),
                ),
                ...widget.todo.subTasks.map((subtask) {
                  TextEditingController subtaskController =
                      TextEditingController(text: subtask.subtaskText);
                  return TextField(
                    controller: subtaskController,
                    decoration: InputDecoration(labelText: 'Subtask'),
                    onChanged: (value) {
                      subtask.subtaskText = value;
                      _saveTasks([widget.todo]);
                    },
                  );
                }).toList(),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                setState(() {
                  widget.todo.todoText = _taskController.text;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double percentage = percentageOfSubtasksCompleted();
    bool allSubtasksCompleted = _areAllSubtasksCompleted();
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          ListTile(
            onTap: () {
              widget.onToDoChanged(widget.todo);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            tileColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ---------------------ToDo---------------------
                    // ---------------------Checkbox---------------------

                    Icon(
                      widget.todo.isDone && widget.todo.subTasks.isEmpty ||
                              allSubtasksCompleted &&
                                  widget.todo.subTasks.isNotEmpty
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: Colors.blue[400],
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.todo.todoText!,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          decoration: widget.todo.isDone &&
                                      widget.todo.subTasks.isEmpty ||
                                  allSubtasksCompleted &&
                                      widget.todo.subTasks.isNotEmpty
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),
                    Text(
                      '${percentage.toStringAsFixed(0)}%',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: widget.todo.isDone &&
                                    widget.todo.subTasks.isEmpty ||
                                allSubtasksCompleted &&
                                    widget.todo.subTasks.isNotEmpty
                            ? Colors.blue
                            : Colors.grey[400],
                      ),
                    ),

                    // ---------------------Edit and Delete buttons---------------------
                    SizedBox(width: 2),
                    IconButton(
                      onPressed: _showEditDialog,
                      icon: Icon(
                        Icons.edit,
                        color: Colors.blue[400],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.red[400],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: IconButton(
                        onPressed: () {
                          widget.onToDoDeleted(widget.todo.id!);
                        },
                        iconSize: 25,
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                // ---------------------Subtasks---------------------
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: Row(),
                ),
                for (SubTask subtask in widget.todo.subTasks)
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                    child: Row(
                      children: [
                        Checkbox(
                          value: subtask.isDone,
                          activeColor: Colors.blue[400],
                          checkColor: Colors.white,
                          side: const BorderSide(color: Colors.blue, width: 2),
                          onChanged: (value) => _handleSubtaskClick(subtask),
                        ),
                        Text(
                          subtask.subtaskText!,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            decoration: subtask.isDone
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),

                // ---------------------Add a new subtask---------------------
                Padding(
                  padding: const EdgeInsets.only(
                    left: 30.0,
                    top: 4.0,
                    right: 50.0,
                  ),
                  child: TextField(
                    controller: _subtaskController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      hintText: 'Add a new task',
                      border: InputBorder.none,
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(bottom: 0.0),
                        child: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _addSubtask,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
