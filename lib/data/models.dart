import 'dart:math';

class NotesModel {
  int? id;
  String title;
  String content;
  bool isImportant;
  DateTime date;

  NotesModel({
    this.id,
    required this.title,
    required this.content,
    this.isImportant = false,
    required this.date,
  });

  factory NotesModel.fromMap(Map<String, Object?> map) {
    return NotesModel(
      id: map['_id'] as int?,
      title: map['title'] as String? ?? '',
      content: map['content'] as String? ?? '',
      isImportant: (map['isImportant'] as int? ?? 0) == 1,
      date: DateTime.tryParse(map['date'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, Object?> toMap() {
    return {
      '_id': id,
      'title': title,
      'content': content,
      'isImportant': isImportant ? 1 : 0,
      'date': date.toIso8601String(),
    };
  }

  NotesModel.random()
      : id = Random().nextInt(1000) + 1,
        title = 'Lorem Ipsum ' * (Random().nextInt(3) + 1),
        content = 'Lorem Ipsum ' * (Random().nextInt(3) + 1),
        isImportant = Random().nextBool(),
        date = DateTime.now().add(Duration(hours: Random().nextInt(100)));
}
