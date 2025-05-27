
class NotesModel {

  final int? id;
  final String title;
  final int age;
  final String description;
  final String email;

  NotesModel({
    this.id,
    required this.title,
    required this.age,
    required this.description,
    required this.email
  });

  factory NotesModel.fromJson(Map<String, dynamic> json) {
    return NotesModel(
      id: json['id'],
      title: json['title'],
      age: json['age'],
      description: json['description'],
      email: json['email'],
    );
  }


  // Convert NotesModel to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'age': age,
      'description': description,
      'email': email,
    };
  }
}