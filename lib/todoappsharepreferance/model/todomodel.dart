class Todomodel {
  final int? id;
  final String title;
  final String description;
  int check;

  Todomodel({
    this.id,
    required this.title,
    required this.description,
    this.check = 0,
  });

  // Factory constructor to create an instance from a Map
  factory Todomodel.fromMap(Map<String, dynamic> map) {
    return Todomodel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      check: map['check'], // Default to 0 if null
    );
  }

  // Convert the instance to a Map
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'check': check,
    };
  }
}
