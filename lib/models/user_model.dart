import 'dart:convert';

import 'package:eleran/helpers/enums.dart';
import 'package:flutter/foundation.dart';

class UserModel {
  String name;
  String id;
  List<CoursesListEnum>? courses;
  UserType userType;
  UserModel({
    required this.name,
    required this.id,
    this.courses,
    required this.userType,
  });

  UserModel copyWith({
    String? name,
    String? id,
    List<CoursesListEnum>? courses,
    UserType? userType,
  }) {
    return UserModel(
      name: name ?? this.name,
      id: id ?? this.id,
      courses: courses ?? this.courses,
      userType: userType ?? this.userType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'courses': courses != null
          ? List.generate(
              courses!.length, (index) => describeEnum(courses![index]))
          : null,
      'userType': describeEnum(userType),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      id: map['id'] ?? '',
      courses: map['courses'] != null
          ? List<CoursesListEnum>.from(map['courses']?.map((x) =>
              CoursesListEnum.values.firstWhere((e) => describeEnum(e) == x)))
          : null,
      userType:
          UserType.values.firstWhere((e) => describeEnum(e) == map['userType']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(name: $name, id: $id, courses: $courses, userType: $userType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.name == name &&
        other.id == id &&
        listEquals(other.courses, courses) &&
        other.userType == userType;
  }

  @override
  int get hashCode {
    return name.hashCode ^ id.hashCode ^ courses.hashCode ^ userType.hashCode;
  }
}

enum UserType { student, staff, admin }
