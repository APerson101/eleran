import 'package:eleran/models/quiz_model.dart';
import 'package:eleran/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../models/question_model.dart';
import '../../providers/create_questions_provider.dart';
import 'history_lecturer.dart';

class QuizQuestionsCreatorView extends ConsumerWidget {
  const QuizQuestionsCreatorView(
      {super.key,
      required this.quizDuration,
      required this.difficulty,
      required this.startDate,
      required this.quizName,
      required this.startTime,
      required this.courses,
      required this.creator});
  final int quizDuration;
  final List<String> courses;
  final DateTime startDate;
  final String quizName;
  final UserModel creator;
  final TimeOfDay startTime;
  final int difficulty;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(saveQuizProvider, (previous, next) {
      next.when(
          data: (state) async {
            if (state == QuizStates.sendingNotification) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  padding: EdgeInsets.all(10),
                  content: Text("Successfully created quiz")));
              Navigator.of(context)
                ..pop()
                ..pop();

              ref.invalidate(getLecturerQuizzes(creator.id));
            }
          },
          error: (er, st) {},
          loading: () {});
    });
    var allQuestionModels =
        ref.watch(createQuestionsProvider(ref.watch(_numberOfQuestions)));
    return AbsorbPointer(
      absorbing: ref.watch(_absord),
      child: Scaffold(
          appBar: AppBar(
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    QuizModel quiz = QuizModel(
                        creatorID: creator.id,
                        quizID: const Uuid().v4(),
                        creatorName: creator.name,
                        quizName: quizName,
                        allQuestions: allQuestionModels,
                        createdDate: DateTime.now(),
                        duration: quizDuration,
                        startDate: startDate,
                        startTime: startTime,
                        relatedCourses: [...courses]);
                    ref.watch(quizModelProvider.notifier).state = quiz;
                    ref.watch(saveQuizProvider.notifier).createQuiz(quiz);
                  },
                  child: const Text("Next"))
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (numberOfQuestions) {
                      ref.watch(_numberOfQuestions.notifier).state =
                          int.tryParse(numberOfQuestions) ?? 0;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        hintText: "Enter number of questions"),
                  ),
                ),
                _QuestionsView(allQuestionModels: allQuestionModels)
              ],
            ),
          )),
    );
  }
}

class _QuestionsView extends ConsumerWidget {
  const _QuestionsView({required this.allQuestionModels});
  final List<QuestionModel> allQuestionModels;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ExpansionPanelList(
      children: List.generate(
        ref.watch(_numberOfQuestions),
        (index) => ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (context, isExpanded) {
            return Text("Question ${index + 1}");
          },
          body: _QuestionContent(
            index: index,
            questionModel: allQuestionModels[index],
          ),
          isExpanded: ref.watch(_allPanels)[index],
        ),
      ),
      expansionCallback: (location, isopen) {
        ref.watch(_allPanels.notifier).update((state) {
          state[location] = !isopen;
          state = [...state];
          return state;
        });
      },
    );
  }
}

final _allPanels = StateProvider.autoDispose(
    (ref) => List.generate(ref.watch(_numberOfQuestions), (index) => false));

final _numberOfQuestions = StateProvider.autoDispose((ref) => 0);

class _QuestionContent extends ConsumerWidget {
  const _QuestionContent({required this.index, required this.questionModel});
  final int index;
  final QuestionModel questionModel;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var updater = ref
        .watch(createQuestionsProvider(ref.watch(_numberOfQuestions)).notifier);
    return SizedBox(
      height: 450,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 15),
            child: TextFormField(
              minLines: 5,
              maxLines: 5,
              onChanged: (question) {
                updater.update(questionModel..question = question, index);
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  hintText:
                      'Type question ${index + 1} and mark correct answers'),
            ),
          ),
          const SizedBox(height: 20),
          ...List.generate(
              4,
              (optionIndex) => Expanded(
                    child: CheckboxListTile(
                        activeColor: Colors.green,
                        value: questionModel.correctAnswers[optionIndex],
                        onChanged: (newValue) {
                          if (newValue != null) {
                            updater.update(
                                questionModel
                                  ..correctAnswers[optionIndex] = newValue,
                                index);
                          }
                        },
                        title: TextFormField(
                          onChanged: (option) {
                            updater.update(
                                questionModel..options[optionIndex] = option,
                                index);
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              hintText: 'Enter Option ${optionIndex + 1}'),
                        )),
                  )),
        ],
      ),
    );
  }
}

final _absord = StateProvider((ref) => false);
