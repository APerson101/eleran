import 'dart:convert';

import 'package:flutter/foundation.dart';

class QuestionModel {
  String question;
  List<bool> correctAnswers;
  List<String> options;
  QuestionModel({
    required this.question,
    required this.correctAnswers,
    required this.options,
  });

  QuestionModel copyWith({
    String? question,
    List<bool>? correctAnswers,
    List<String>? options,
  }) {
    return QuestionModel(
      question: question ?? this.question,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      options: options ?? this.options,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'correctAnswers': correctAnswers,
      'options': options,
    };
  }

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      question: map['question'] ?? '',
      correctAnswers: List<bool>.from(map['correctAnswers']),
      options: List<String>.from(map['options']),
    );
  }

  String toJson() => json.encode(toMap());

  factory QuestionModel.fromJson(String source) =>
      QuestionModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'QuestionModel(question: $question, correctAnswers: $correctAnswers, options: $options)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuestionModel &&
        other.question == question &&
        listEquals(other.correctAnswers, correctAnswers) &&
        listEquals(other.options, options);
  }

  @override
  int get hashCode =>
      question.hashCode ^ correctAnswers.hashCode ^ options.hashCode;
}
