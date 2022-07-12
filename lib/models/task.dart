class Task {
  bool completed;
  String description;

  Task({required this.description, this.completed = false});

  factory Task.fromJson(Map<dynamic, dynamic> json) => Task(description: json['description'], completed: json['completed']);

  Map<dynamic, dynamic> toJson() {
    return {"description": description, "completed": completed};
  }
}
