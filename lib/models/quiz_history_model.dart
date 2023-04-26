import 'dart:convert';

import 'package:flutter/foundation.dart';

class QuizHistoryModel {
  String quizName;
  List<bool> answers;
  String quizID;
  DateTime quizTaken;
  QuizHistoryModel({
    required this.quizName,
    required this.answers,
    required this.quizID,
    required this.quizTaken,
  });

  QuizHistoryModel copyWith({
    String? quizName,
    List<bool>? answers,
    String? quizID,
    DateTime? quizTaken,
  }) {
    return QuizHistoryModel(
      quizName: quizName ?? this.quizName,
      answers: answers ?? this.answers,
      quizID: quizID ?? this.quizID,
      quizTaken: quizTaken ?? this.quizTaken,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'quizName': quizName,
      'answers': answers,
      'quizID': quizID,
      'quizTaken': quizTaken.millisecondsSinceEpoch,
    };
  }

  factory QuizHistoryModel.fromMap(Map<String, dynamic> map) {
    return QuizHistoryModel(
      quizName: map['quizName'] ?? '',
      answers: List<bool>.from(map['answers']),
      quizID: map['quizID'] ?? '',
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
