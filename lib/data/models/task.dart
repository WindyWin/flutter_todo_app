class Task {
  int? id;
  String? title;
  String? content;
  bool? isDone;
  DateTime? createAt;
  Task({this.id, this.content, this.createAt, this.isDone, this.title});

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      "id": id,
      "title": title,
      "content": content,
      "isDone": isDone! ? 1 : 0,
      "createAt": createAt!.toIso8601String(),
    };

    return map;
  }

  Task.fromMap(Map<dynamic, dynamic> map) {
    id = map["id"];
    title = map["title"];
    content = map["content"];
    isDone = map["isDone"] == 1;
    createAt = DateTime.parse(map["createAt"]);
  }
}
