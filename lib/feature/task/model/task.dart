class Todo {
  String? id;
  String title;
  String description;
  DateTime createdTime;

  Todo(
      {required this.description,
      required this.title,
      required this.createdTime,
      this.id});

  Todo copyWith(
      {String? id, String? title, String? description, DateTime? createdTime}) {
    return Todo(
        id: id ?? this.id,
        description: description ?? this.description,
        title: title ?? this.title,
        createdTime: createdTime ?? this.createdTime);
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      description: json['description'],
      title: json['title'],
      createdTime: json['createdTime'].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['title'] = title;
    json['description'] = description;
    json['createdTime'] = createdTime;
    return json;
  }
}
