class Customer {
  final int id;
  final String title;
  final String note;
  final String color;

  Customer({
    this.id,
    this.title,
    this.note,
    this.color,
  });

  Map<String,dynamic> toMap(){ // used when inserting data to the database
    return <String,dynamic>{
      "id" : id,
      "title" : title,
      "note" : note,
      "color" : color,
    };
  }
}