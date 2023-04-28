import 'package:eleran/models/quiz_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/question_model.dart';
import 'quiz_creation_update.dart';

class QuizQuestionsCreatorView extends ConsumerWidget {
  const QuizQuestionsCreatorView(
      {super.key,
      required this.quizDuration,
      required this.difficulty,
      required this.startDate,
      required this.startTime,
      required this.courses});
  final int quizDuration;
  final List<String> courses;
  final DateTime startDate;
  final TimeOfDay startTime;
  final int difficulty;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<QuestionModel> allQuestionModels = List.generate(
        ref.watch(_numberOfQuestions),
        (index) => QuestionModel(
            question: '',
            correctAnswers: List.generate(4, (index) => false),
            options: List.generate(4, (index) => '')));
    return Scaffold(
        appBar: AppBar(
          actions: [
            ElevatedButton(
                onPressed: () async {
                  QuizModel quiz = QuizModel(
                      creatorID: 'testID',
                      quizID: 'testquizID',
                      creatorName: 'Abba baba',
                      quizName: 'Midterm 1',
                      allQuestions: allQuestionModels,
                      createdDate: DateTime.now(),
                      duration: quizDuration,
                      startDate: startDate,
                      startTime: startTime,
                      relatedCourses: courses);
                  ref.watch(quizModelProvider.notifier).state = quiz;
                  for (var element in allQuestionModels) {
                    debugPrint(element.toMap().toString());
                  }
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const QuizCreationUpdate()));
                },
                child: const Text("Next"))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                onChanged: (numberOfQuestions) {
                  ref.watch(_numberOfQuestions.notifier).state =
                      int.tryParse(numberOfQuestions) ?? 0;
                },
                decoration: const InputDecoration(
                    hintText: "Enter number of questions"),
              ),
              _QuestionsView(allQuestionModels: allQuestionModels)
            ],
          ),
        ));
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

class _QuestionContent extends StatefulWidget {
  _QuestionContent({required this.index, required this.questionModel});
  final int index;
  QuestionModel questionModel;
  @override
  State<_QuestionContent> createState() => __QuestionContentState();
}

class __QuestionContentState extends State<_QuestionContent> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextField(
            onChanged: (question) {
              widget.questionModel.question = question;
            },
            decoration: InputDecoration(
                hintText:
                    'Type question ${widget.index.toString()} and mark correct answers'),
          ),
          const SizedBox(height: 40),
          ...List.generate(
              4,
              (index) => Expanded(
                    child: CheckboxListTile(
                        value: widget.questionModel.correctAnswers[index],
                        onChanged: (newValue) {
                          setState(() {
                            if (newValue != null) {
                              widget.questionModel.correctAnswers[index] =
                                  newValue;
                            }
                          });
                        },
                        title: TextField(
                          onChanged: (option) {
                            widget.questionModel.options[index] = option;
                          },
                          decoration: InputDecoration(
                              hintText: 'Enter Option ${index + 1}'),
                        )),
                  )),
        ],
      ),
    );
  }
}
