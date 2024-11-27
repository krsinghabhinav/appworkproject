class Todomodel {
  final int? id;
  final String title;
  final String description;
  int checkbox;

  Todomodel({
    this.id,
    required this.title,
    required this.description,
    this.checkbox = 0,
  });

  // Factory constructor to create an instance from a Map
  factory Todomodel.fromMap(Map<String, dynamic> map) {
    return Todomodel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      checkbox: map['checkbox'], // Default to 0 if null
    );
  }

  // Convert the instance to a Map
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'checkbox': checkbox,
    };
  }
}
