import 'dart:convert';

import 'package:flutter/foundation.dart';

class QuizHistoryModel {
  String quizName;
  String userName;
  String userID;
  List<bool> answers;
  String quizID;
  DateTime quizTaken;
  QuizHistoryModel(
      {required this.quizName,
      required this.answers,
      required this.quizID,
      required this.quizTaken,
      required this.userID,
      required this.userName});

  Map<String, dynamic> toMap() {
    return {
      'quizName': quizName,
      'answers': answers,
      'quizID': quizID,
      'userName': userName,
      'userID': userID,
      'quizTaken': quizTaken.millisecondsSinceEpoch,
    };
  }

  factory QuizHistoryModel.fromMap(Map<String, dynamic> map) {
    return QuizHistoryModel(
      quizName: map['quizName'] ?? '',
      answers: List<bool>.from(map['answers']),
      quizID: map['quizID'] ?? '',
      userID: map['userID'],
      userName: map['userName'],
      quizTaken: DateTime.fromMillisecondsSinceEpoch(map['quizTaken']),
    );
  }

  String toJson() => json.encode(toMap());

  factory QuizHistoryModel.fromJson(String source) =>
      QuizHistoryModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'QuizHistoryModel(quizName: $quizName, answers: $answers, quizID: $quizID, quizTaken: $quizTaken)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuizHistoryModel &&
        other.quizName == quizName &&
        listEquals(other.answers, answers) &&
        other.quizID == quizID &&
        other.quizTaken == quizTaken;
  }

  @override
  int get hashCode {
    return quizName.hashCode ^
        answers.hashCode ^
        quizID.hashCode ^
        quizTaken.hashCode;
  }
}
