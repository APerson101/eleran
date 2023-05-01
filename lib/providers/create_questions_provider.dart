import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../helpers/db.dart';
import '../models/question_model.dart';
import '../models/quiz_model.dart';

part 'create_questions_provider.g.dart';

@riverpod
class CreateQuestions extends _$CreateQuestions {
  @override
  List<QuestionModel> build(int numberOfQuestions) {
    return List.generate(
        numberOfQuestions,
        (index) => QuestionModel(
            question: '',
            correctAnswers: List.generate(4, (index) => false),
            options: List.generate(4, (index) => '')));
  }

  update(QuestionModel newQuestion, int index) {
    state[index] = newQuestion;
    state = [...state];
  }
}

enum QuizStates { creatingQuiz, sendingNotification, notificationSuccess, idle }

@riverpod
class SaveQuiz extends _$SaveQuiz {
  @override
  FutureOr<QuizStates> build() {
    return QuizStates.idle;
  }

  createQuiz(QuizModel quizzModel) async {
    var quizCollection = GetIt.I<FirebaseFirestore>().collection('Quizzes');
    state = const AsyncData(QuizStates.creatingQuiz);
    await quizCollection.add(quizzModel.toMap());
    state = const AsyncData(QuizStates.sendingNotification);
    await GetIt.I<Database>().notifyquizUpdate(quizzModel.relatedCourses);
    state = const AsyncData(QuizStates.notificationSuccess);
  }
}

final sendNotification = FutureProvider((ref) async {
  var quizzModel = ref.read(quizModelProvider);
  assert(quizzModel != null);
  return await GetIt.I<Database>().notifyquizUpdate(quizzModel!.relatedCourses);
});

final quizModelProvider = StateProvider.autoDispose<QuizModel?>((ref) => null);
