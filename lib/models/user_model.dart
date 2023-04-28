import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserModel {
  String name;
  String id;
  List<String>? courses;
  UserType userType;
  String? fcmToken;
  UserModel({
    required this.name,
    required this.id,
    this.courses,
    required this.userType,
    this.fcmToken,
  });

  UserModel copyWith({
    String? name,
    String? id,
    List<String>? courses,
    UserType? userType,
    String? fcmToken,
  }) {
    return UserModel(
      name: name ?? this.name,
      id: id ?? this.id,
      courses: courses ?? this.courses,
      userType: userType ?? this.userType,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'courses': courses,
      'userType': describeEnum(userType),
      'fcmToken': fcmToken,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      id: map['id'] ?? '',
      courses: List<String>.from(map['courses']),
      userType: UserType.values
          .firstWhere((element) => describeEnum(element) == map['userType']),
      fcmToken: map['fcmToken'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(name: $name, id: $id, courses: $courses, userType: $userType, fcmToken: $fcmToken)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.name == name &&
        other.id == id &&
        listEquals(other.courses, courses) &&
        other.userType == userType &&
        other.fcmToken == fcmToken;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        id.hashCode ^
        courses.hashCode ^
        userType.hashCode ^
        fcmToken.hashCode;
  }
}

enum UserType { student, staff, admin }
