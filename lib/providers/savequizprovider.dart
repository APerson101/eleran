import 'package:eleran/helpers/db.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'countdownprovider.dart';

part 'savequizprovider.g.dart';

enum SaveQuizEnums { success, failure, idle }

@riverpod
class SaveQuiz extends _$SaveQuiz {
  @override
  FutureOr<SaveQuizEnums> build() {
    return SaveQuizEnums.idle;
  }

  saveAnswer(
      String quizID,
      String studentID,
      List<bool> answers,
      String quizName,
      DateTime quizTaken,
      String userName,
      String userID) async {
    try {
      await GetIt.I<Database>().saveQuizAnswer(
          quizID, studentID, answers, quizName, quizTaken, userName, userID);
      state = const AsyncData(SaveQuizEnums.success);
      ref.watch(stopQuizProvider.notifier).state = QuizEndEnum.result;
    } catch (e) {
      debugPrint(e.toString());
      state = const AsyncData(SaveQuizEnums.failure);
    }
  }
}
