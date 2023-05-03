import 'package:eleran/mainapp/student_quiz_result.dart';
import 'package:eleran/models/quiz_model.dart';
import 'package:eleran/providers/countdownprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';
import '../providers/savequizprovider.dart';

class TakeQuizView extends ConsumerWidget {
  const TakeQuizView({super.key, required this.quiz, required this.user});
  final QuizModel quiz;
  final UserModel user;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(saveQuizProvider, (previous, next) {
      if (previous != next) {
        next.when(
            data: (data) {
              if (data == SaveQuizEnums.success) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("saved success!")));
              }

              if (data == SaveQuizEnums.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Failed to save")));
              }
            },
            error: (er, st) {
              debugPrintStack(stackTrace: st);
            },
            loading: () {});
      }
    });
    var answersState = ref.watch(userAnswersToQuizProvider(quiz).notifier);
    var question = quiz.allQuestions[ref.watch(_currentPage)];
    var timeLeft = ref.watch(quizEndNumberProvider(quiz.duration)).when(
        data: (time) => time,
        error: (Object error, StackTrace stackTrace) {
          return -1;
        },
        loading: () {
          return -1;
        });
    if (ref.watch(stopQuizProvider) == QuizEndEnum.quiz) {
      var current = ref.watch(_currentPage);

      return Scaffold(
        appBar: AppBar(
          title: Text("Time left: $timeLeft seconds"),
        ),
        body: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(question.question),
                  ...question.options.map((e) {
                    return ListTile(
                        onTap: () {
                          answersState.update(
                              quiz.allQuestions.indexOf(question),
                              question.options.indexOf(e));
                        },
                        selectedTileColor: Colors.greenAccent,
                        selected: answersState
                                .state[quiz.allQuestions.indexOf(question)]
                            [question.options.indexOf(e)],
                        shape: RoundedRectangleBorder(
                            side:
                                const BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(30)),
                        leading:
                            Text((question.options.indexOf(e) + 1).toString()),
                        title: Text(e));
                  }),
                  ButtonBar(
                    alignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            ref.watch(_currentPage.notifier).state =
                                current - 1;
                          },
                          child: const Text("Previous")),
                      ElevatedButton(
                          onPressed: () {
                            if (current != quiz.allQuestions.length - 1) {
                              ref.watch(_currentPage.notifier).state =
                                  current + 1;
                            } else {
                              //save score then move to the nex pae
                              var answers =
                                  calculateScore(quiz, answersState.state);
                              ref.watch(saveQuizProvider.notifier).saveAnswer(
                                  quiz.quizID,
                                  user.id,
                                  answers,
                                  quiz.quizName,
                                  DateTime.now(),
                                  user,
                                  user.name,
                                  user.id);
                            }
                          },
                          child: Text(current != quiz.allQuestions.length - 1
                              ? "Next"
                              : "Show score")),
                    ],
                  )
                ]),
          ),
        ),
      );
    }
    var scores = calculateScore(quiz, answersState.state);
    return StudentQuizResultView(
      correctAnswersLength: scores.where((element) => element).toList().length,
      totalQuestionsLength: scores.length,
    );
  }

  List<bool> calculateScore(QuizModel quiz, List<List<bool?>> userAnswers) {
    var questionIndex = 0;
    int correct = 0;
    bool optionCorrect = false;
    List<bool> answersreturn =
        List.generate(quiz.allQuestions.length, (index) => false);
    for (var question in quiz.allQuestions) {
      var answers = question.correctAnswers;
      int answerIndex = 0;
      for (var answer in answers) {
        if (answer == userAnswers[questionIndex][answerIndex]) {
          optionCorrect = true;
        } else {
          optionCorrect = false;
          break;
        }
        answerIndex += 1;
      }
      if (optionCorrect == true) {
        answersreturn[questionIndex] = true;
        correct += 1;
      } else {
        answersreturn[questionIndex] = false;
      }
      questionIndex += 1;
    }
    return answersreturn;
  }
}

final _currentPage = StateProvider((ref) => 0);
