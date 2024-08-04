import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_list/models/todo.dart';
import 'package:to_do_list/widgets/search.dart';
import 'package:to_do_list/widgets/todo_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final todosList = ToDo.todoList();
  List<ToDo> searchList = [];
  final toDoText = TextEditingController();

  void _handleClick(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
      if (todo.subTasks.isNotEmpty) {
        for (SubTask subtask in todo.subTasks) {
          subtask.isDone = todo.isDone;
        }
      }
      _saveTasks(todosList);
    });
  }

  // ---------------------Delete---------------------
  void _handleDelete(String id) {
    setState(() {
      todosList.removeWhere((item) => item.id == id);
    });
    _saveTasks(todosList);
  }

  // ---------------------Add New ToDo---------------------

  void _addNewToDo(String title) {
    setState(() {
      todosList.add(ToDo(
        id: DateTime.now().toString(),
        todoText: title,
      ));
    });
    toDoText.clear();
    _saveTasks(todosList);
  }

  // ---------------------Search---------------------

  void search(String SearchWords) {
    List<ToDo> results = [];
    if (SearchWords.isEmpty) {
      results = todosList;
    } else {
      results = todosList
          .where((item) =>
              item.todoText!.toLowerCase().contains(SearchWords.toLowerCase()))
          .toList();
    }

    setState(() {
      searchList = results;
    });
  }

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

  @override
  void initState() {
    super.initState();
    _loadTasks().then((loadedTodos) {
      setState(() {
        todosList.clear();
        todosList.addAll(loadedTodos);
        searchList = todosList; // Update searchList after loading tasks
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(240, 255, 255, 255),
        body: Stack(
          children: [
            Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 60,
                ),
                child: Column(
                  children: [
                    // ---------------------Search---------------------
                    searchBox(search),
                    // ---------------------All ToDos---------------------
                    Expanded(
                        child: ListView(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            bottom: 20,
                          ),
                          child: Text(
                            "All ToDos",
                            style: GoogleFonts.poppins(
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        for (ToDo todo in searchList)
                          ToDoItem(
                              todo: todo,
                              onToDoChanged: _handleClick,
                              onToDoDeleted: _handleDelete),
                      ],
                    ))
                  ],
                )),

            // ---------------------Add ToDo---------------------
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                    margin: const EdgeInsets.only(
                      bottom: 20,
                      right: 20,
                      left: 20,
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(0, 0),
                          blurRadius: 10,
                          spreadRadius: 0,
                        )
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),

                    // ---------------------TextField---------------------
                    child: TextField(
                      controller: toDoText,
                      decoration: const InputDecoration(
                        hintText: "Add a new ToDo",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                      ),
                    ),
                  )),
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 20,
                      right: 20,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue[400],
                        minimumSize: Size(10, 65),
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Adjust the value for more or less rounded corners
                        ),
                      ),
                      onPressed: () {
                        _addNewToDo(toDoText.text);
                      },
                      child: const Icon(
                        color: Colors.white,
                        Icons.add,
                        size: 30,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
