import 'package:eleran/helpers/db.dart';
import 'package:eleran/mainapp/quiz_waiting_page.dart';
import 'package:eleran/mainapp/student/profile_view.dart';
import 'package:eleran/mainapp/student/search_view.dart';
import 'package:eleran/models/quiz_history_model.dart';
import 'package:eleran/models/quiz_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../models/user_model.dart';

class StudentView extends ConsumerWidget {
  const StudentView({super.key, required this.user});
  final UserModel user;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(_currentViewProvider) == 0
          ? DashboardView(user: user)
          : ref.watch(_currentViewProvider) == 1
              ? StudentSearchView(user: user)
              : StudentProfileView(user: user),
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          currentIndex: ref.watch(_currentViewProvider),
          onTap: (next) {
            ref.watch(_currentViewProvider.notifier).state = next;
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard), label: "Dashboard"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ]),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({
    super.key,
    required this.user,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  height: 100,
                  child: _PendingQuiz(user: user)),
              Positioned(
                  top: 250,
                  left: 0,
                  right: 0,
                  height: 100,
                  child: _QuizzesHistory(user: user)),
            ],
          ),
        ),
      ),
    );
  }
}

class _PendingQuiz extends ConsumerWidget {
  const _PendingQuiz({required this.user});
  final UserModel user;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getUpComingQuiz(user)).when(data: (quizzes) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return _QuizzesView(quizzes: quizzes);
          }));
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.lightGreen,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(child: Text("Upcoming quiz is: ${quizzes.length}")),
        ),
      );
    }, error: (Object error, StackTrace stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      return const Center(
        child: Text('error doing stuff'),
      );
    }, loading: () {
      return const CircularProgressIndicator.adaptive();
    });
  }
}

class _QuizzesView extends ConsumerWidget {
  const _QuizzesView({required this.quizzes});
  final List<QuizModel> quizzes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
          children: quizzes
              .map((e) => ListTile(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return QuizWaitingPageView(quizID: e.quizID);
                      }));
                    },
                    title: Text(e.creatorName),
                    subtitle: Text(e.startDate.toIso8601String()),
                    trailing: Text(e.startTime.toString()),
                  ))
              .toList()),
    );
  }
}

class _QuizzesHistory extends ConsumerWidget {
  const _QuizzesHistory({required this.user});
  final UserModel user;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        //move to detailed view
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return _PreviousQuizHistory(user: user);
        }));
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: Colors.amberAccent, borderRadius: BorderRadius.circular(30)),
        child: const Center(child: Text('View previously taken quizzes')),
      ),
    );
  }
}

class _PreviousQuizHistory extends ConsumerWidget {
  const _PreviousQuizHistory({required this.user});
  final UserModel user;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getUserQuizHistory(user)).when(data: (history) {
      return Scaffold(
          appBar: AppBar(),
          body: Column(
              children: history
                  .map((e) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(e.quizName),
                          trailing: Text(e.quizTaken.toIso8601String()),
                          subtitle: Text(
                              '${e.answers.where((element) => element).length} / ${e.answers.length}'),
                        ),
                      ))
                  .toList()));
    }, error: (Object error, StackTrace stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      return const Material(
          child: Center(
        child: Text("Failed to load"),
      ));
    }, loading: () {
      return const Material(
        child: Center(child: CircularProgressIndicator.adaptive()),
      );
    });
  }
}

final getUpComingQuiz =
    FutureProvider.family<List<QuizModel>, UserModel>((ref, user) async {
  var db = GetIt.I<Database>();
  return await db.getPending(user: user);
});

final getUserQuizHistory =
    FutureProvider.family<List<QuizHistoryModel>, UserModel>((ref, user) async {
  var db = GetIt.I<Database>();
  return await db.getUserQuizHistory(user);
});

final _currentViewProvider = StateProvider((ref) => 0);
