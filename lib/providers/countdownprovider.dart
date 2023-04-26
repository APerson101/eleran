import 'dart:async';

import 'package:eleran/models/quiz_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'countdownprovider.g.dart';

enum StartQuizEnum { countdown, start }

enum QuizEndEnum { quiz, result }

@riverpod
class CountDownNumber extends _$CountDownNumber {
  @override
  AsyncValue<int> build(DateTime timeStarting) {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      var time = timeStarting.difference(DateTime.now()).inSeconds;
      if (time == 0) {
        ref.watch(startquizProvider.notifier).state = StartQuizEnum.start;
        timer.cancel();
      }
      if (time < 0) {
        ref.watch(startquizProvider.notifier).state = StartQuizEnum.start;
        timer.cancel();
      }
      state = AsyncData(time);
    });
    return const AsyncData(0);
  }
}

@riverpod
class QuizEndNumber extends _$QuizEndNumber {
  @override
  AsyncValue<int> build(int quizTime) {
    int startTime = Duration(minutes: quizTime).inSeconds;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      startTime--;
      if (startTime == 0) {
        ref.watch(stopQuizProvider.notifier).state = QuizEndEnum.result;
        timer.cancel();
      }
      state = AsyncData(startTime);
    });
    return AsyncData(startTime);
  }
}

@riverpod
class UserAnswersToQuiz extends _$UserAnswersToQuiz {
  @override
  List<List<bool>> build(QuizModel quizModel) {
    // var quiz = ref.watch(activeQuizProvider);
    return List.generate(quizModel.allQuestions.length,
        (index) => List.generate(4, (index) => false));
  }

  update(int question, int option) {
    var currentState = state[question][option];

    if (currentState == null) {
      state[question][option] = true;
      return;
    } else {
      state[question][option] = !currentState;
      return;
    }
  }
}

final startquizProvider =
    StateProvider.autoDispose((ref) => StartQuizEnum.countdown);

final stopQuizProvider = StateProvider.autoDispose((ref) => QuizEndEnum.quiz);
