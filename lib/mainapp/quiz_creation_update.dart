import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eleran/models/quiz_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../helpers/db.dart';

class QuizCreationUpdate extends ConsumerWidget {
  const QuizCreationUpdate({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(_creteQuiz).when(
          data: (status) {
            return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                  Text(status),
                  status == 'Creating Quiz'
                      ? const CircularProgressIndicator.adaptive()
                      : ElevatedButton(
                          onPressed: () {
                            debugPrint("Done with them stuff");
                          },
                          child: const Text("Home"))
                ]));
          },
          error: (er, st) {
            return null;
          },
          loading: () =>
              const Center(child: CircularProgressIndicator.adaptive())),
    );
  }
}

final _creteQuiz = StreamProvider<String>((ref) async* {
  yield 'Creating Quiz';
  var quizzModel = ref.read(quizModelProvider);
  var quizCollection = GetIt.I<FirebaseFirestore>().collection('Quizzes');

  if (quizzModel != null) {
    var status = await quizCollection
        .add(quizzModel.toMap())
        .then((value) => 'SuccessFully Created New Quiz')
        .catchError((onError) => 'Failed to Create Quiz');
    yield status;
    ref.watch(_sendNotification).when(data: (status) async* {
      yield status
          ? 'Sucessfully notified students'
          : 'Failed to send Notifications';
    }, error: (er, st) async* {
      yield 'Failed to Notify Students';
    }, loading: () async* {
      yield 'Notifying Students';
    });
  } else {
    yield 'Quiz not found';
  }

  // after creating quiz, notify users;
});

final _sendNotification = FutureProvider((ref) async {
  var quizzModel = ref.read(quizModelProvider);
  assert(quizzModel != null);
  return await GetIt.I<Database>().notifyquizUpdate(quizzModel!.relatedCourses);
});

final quizModelProvider = StateProvider.autoDispose<QuizModel?>((ref) => null);
