import 'dart:convert';

import 'package:eleran/helpers/enums.dart';
import 'package:eleran/models/question_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class QuizModel {
  String creatorID;
  String creatorName;
  String quizID;
  String quizName;
  List<QuestionModel> allQuestions;
  DateTime createdDate;
  int duration;
  List<CoursesListEnum> relatedCourses;
  DateTime startDate;
  TimeOfDay startTime;
  QuizModel(
      {required this.creatorID,
      required this.quizID,
      required this.quizName,
      required this.allQuestions,
      required this.creatorName,
      required this.createdDate,
      required this.duration,
      required this.startDate,
      required this.startTime,
      required this.relatedCourses});

  Map<String, dynamic> toMap() {
    return {
      'creatorID': creatorID,
      'quizID': quizID,
      'allQuestions': allQuestions.map((x) => x.toMap()).toList(),
      'createdDate': createdDate.millisecondsSinceEpoch,
      'duration': duration,
      'quizName': quizName,
      'creatorName': creatorName,
      'startDate': startDate.millisecondsSinceEpoch,
      'startTime': {'hour': startTime.hour, 'min': startTime.minute},
      'courses': relatedCourses.map((course) => describeEnum(course)).toList()
    };
  }

  factory QuizModel.fromMap(Map<String, dynamic> map) {
    var courses = map['courses'] as List;
    var enumCourses = courses
        .map((course) => CoursesListEnum.values
            .firstWhere((element) => describeEnum(element) == course))
        .toList();
    return QuizModel(
        creatorID: map['creatorID'] ?? '',
        quizID: map['quizID'],
        creatorName: map['creatorName'],
        quizName: map['quizName'],
        allQuestions: List<QuestionModel>.from(
            map['allQuestions']?.map((x) => QuestionModel.fromMap(x))),
        createdDate: DateTime.fromMillisecondsSinceEpoch(map['createdDate']),
        duration: map['duration']?.toInt() ?? 0,
        startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
        startTime: TimeOfDay(
            hour: map['startTime']['hour'], minute: map['startTime']['min']),
        relatedCourses: enumCourses);
  }

  String toJson() => json.encode(toMap());

  factory QuizModel.fromJson(String source) =>
      QuizModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'QuizModel(quizID: $quizID courses:${relatedCourses.toString()}   creatorID: $creatorID, allQuestions: $allQuestions, createdDate: $createdDate, duration: $duration, startDate: $startDate, startTime: $startTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuizModel &&
        other.creatorID == creatorID &&
        listEquals(other.allQuestions, allQuestions) &&
        other.createdDate == createdDate &&
        other.duration == duration &&
        other.startDate == startDate &&
        other.startTime == startTime;
  }

  @override
  int get hashCode {
    return creatorID.hashCode ^
        allQuestions.hashCode ^
        createdDate.hashCode ^
        duration.hashCode ^
        startDate.hashCode ^
        startTime.hashCode;
  }
}
