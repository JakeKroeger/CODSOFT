class ToDo {
  String? id;
  String? todoText;
  bool isDone;
  List<SubTask> subTasks = [];

  ToDo({
    this.id,
    this.todoText,
    this.isDone = false,
    List<SubTask>? subTasks,
  }) : subTasks = subTasks ?? [];

  static List<ToDo> todoList() {
    return [
      ToDo(id: '01', todoText: 'Morning Excercise', isDone: true),
      ToDo(id: '02', todoText: 'Buy Groceries', isDone: true),
      ToDo(
        id: '03',
        todoText: 'Check Emails',
        subTasks: [
          SubTask(subtaskText: 'Reply to Jenny'),
          SubTask(subtaskText: 'Send report to boss'),
        ],
      ),
      ToDo(
        id: '04',
        todoText: 'Team Meeting',
      ),
      ToDo(
        id: '05',
        todoText: 'Work on mobile apps for 2 hour',
      ),
      ToDo(
        id: '06',
        todoText: 'Dinner with Jenny',
      ),
    ];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'todoText': todoText,
        'isDone': isDone,
        'subTasks': subTasks.map((subtask) => subtask.toJson()).toList(),
      };

  static ToDo fromJson(Map<String, dynamic> json) => ToDo(
        id: json['id'],
        isDone: json['isDone'],
        todoText: json['todoText'],
        subTasks: (json['subTasks'] as List)
            .map((subtask) => SubTask.fromJson(subtask))
            .toList(),
      );
}

class SubTask {
  String? subtaskText;
  bool isDone;

  SubTask({
    required this.subtaskText,
    this.isDone = false,
  });

  Map<String, dynamic> toJson() => {
        'subtaskText': subtaskText,
        'isDone': isDone,
      };

  static SubTask fromJson(Map<String, dynamic> json) => SubTask(
        subtaskText: json['subtaskText'],
        isDone: json['isDone'],
      );
}
