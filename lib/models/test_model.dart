class Note{
  int id;
  String title;
  String note;
  String color;

//  Note({this.title, this.note, this.color});
//  Note.withId({this.id, this.title, this.note, this.color});
  Note({this.id, this.title, this.note, this.color});

//  Map<String, dynamic> toMap() {
//    final map = Map<String, dynamic>();
//    map['id'] = id;
//    map['title'] = title;
//    map['note'] = note;
//    map['color'] = color;
//    return map;
//  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': title,
      'age': note,
      'color': color,
    };
  }

//  factory Note.fromMap(Map<String, dynamic> map) {
//    return Note.withId(
//      id: map['id'],
//      title: map['title'],
//      note: map['note'],
//      color: map['color'],
//    );
//  }

  @override
  String toString() {
    return 'Note{id: $id, name: $title, note: $note, color: $color}';
  }
}