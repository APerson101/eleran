import 'dart:convert';

class CourseModel {
  String name;
  DateTime dateAdded;
  CourseModel({
    required this.name,
    required this.dateAdded,
  });

  CourseModel copyWith({
    String? name,
    DateTime? dateAdded,
  }) {
    return CourseModel(
      name: name ?? this.name,
      dateAdded: dateAdded ?? this.dateAdded,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dateAdded': dateAdded.millisecondsSinceEpoch,
    };
  }

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      name: map['name'] ?? '',
      dateAdded: DateTime.fromMillisecondsSinceEpoch(map['dateAdded']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CourseModel.fromJson(String source) =>
      CourseModel.fromMap(json.decode(source));

  @override
  String toString() => 'CourseModel(name: $name, dateAdded: $dateAdded)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CourseModel &&
        other.name == name &&
        other.dateAdded == dateAdded;
  }

  @override
  int get hashCode => name.hashCode ^ dateAdded.hashCode;
}
