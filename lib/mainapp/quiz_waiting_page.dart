import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eleran/models/quiz_model.dart';
import 'package:eleran/providers/countdownprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../models/user_model.dart';
import 'take_quiz_view.dart';

class QuizWaitingPageView extends ConsumerWidget {
  const QuizWaitingPageView(
      {super.key, required this.quizID, required this.user});
  final UserModel user;
  final String quizID;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(_getQuizInfo(quizID)).when(data: (quiz) {
      var status = ref.watch(startquizProvider);
      var timeLeft = ref
          .watch(CountDownNumberProvider(DateTime(
              quiz.startDate.year,
              quiz.startDate.month,
              quiz.startDate.day,
              quiz.startTime.hour,
              quiz.startTime.minute)))
          .when(data: (data) => data, error: (er, st) => -1, loading: () => -1);
      return status == StartQuizEnum.countdown
          ? Scaffold(
              body: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset('animations/waiting.json',
                          width: 150,
                          repeat: true,
                          height: 150,
                          onLoaded: (composition) {}),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const SizedBox(width: 20.0),
                          const Text(
                            'Seconds left is: ',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          const SizedBox(width: 20.0),
                          AnimatedTextKit(
                            repeatForever: true,
                            pause: const Duration(seconds: 0),
                            animatedTexts: [
                              RotateAnimatedText('$timeLeft',
                                  duration: const Duration(seconds: 1),
                                  textStyle: TextStyle(
                                      fontSize: 20,
                                      color: timeLeft < 100
                                          ? Colors.red
                                          : Colors.blue)),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          : TakeQuizView(quiz: quiz, user: user);
    }, error: (Object error, StackTrace stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      return const Center(
        child: Text("failed to load"),
      );
    }, loading: () {
      return const Center(child: CircularProgressIndicator.adaptive());
    });
  }
}

final _getQuizInfo =
    FutureProvider.family<QuizModel, String>((ref, quizid) async {
  // Quiz Info
  debugPrint('getting quiz for id:$quizid');
  var store = FirebaseFirestore.instance;
  var quizData = (await store
          .collection('Quizzes')
          .where('quizID', isEqualTo: quizid)
          .limit(1)
          .get())
      .docs[0];
  var quiz = QuizModel.fromMap(quizData.data());
  return quiz;
});
