import 'package:eleran/mainapp/lecturer/quiz_questions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../main.dart';
import '../../models/coursemodel.dart';
import '../../models/user_model.dart';

class CreateQuizView extends ConsumerWidget {
  const CreateQuizView({super.key, required this.user});
  final UserModel user;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('welcome ${user.name}'),
        ),
        body: SafeArea(
          child: Form(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8, top: 0, bottom: 9),
                      child: Row(
                        children: const [
                          Expanded(child: Divider()),
                          Expanded(child: Text("Create new Quiz")),
                          Expanded(child: Divider()),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: _QuizName(),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15.0, right: 15, top: 10),
                      child: _SelectCourseWidget(user),
                    ),
                    const _DateWidget(),
                    const _TimeWidget(),
                    const _DurationWidget(),
                    const SizedBox(
                      height: 75,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 15),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 60)),
                          onPressed: () {
                            // do some validation
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => QuizQuestionsCreatorView(
                                        quizDuration:
                                            ref.watch(_selectedDuration) ?? 0,
                                        difficulty: 0,
                                        startDate: ref.watch(_selectedDate) ??
                                            DateTime.now(),
                                        startTime: ref.watch(_selectedTime) ??
                                            TimeOfDay.now(),
                                        quizName: ref.watch(_selectedQuizName),
                                        creator: user,
                                        courses: [
                                          user.courses![
                                              ref.watch(_selectedCourse)]
                                        ])));
                          },
                          child: const Text("NEXT")),
                    )
                  ]),
            ),
          ),
        ));
  }
}

class _QuizName extends ConsumerWidget {
  const _QuizName();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10),
      child: TextFormField(
        onTapOutside: (ev) => FocusScope.of(context).unfocus(),
        onChanged: (name) {
          name.isNotEmpty
              ? ref.watch(_selectedQuizName.notifier).state = name
              : null;
        },
        decoration: InputDecoration(
            labelText: 'Enter quiz name',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
      ),
    );
  }
}

class _SelectCourseWidget extends ConsumerWidget {
  const _SelectCourseWidget(this.user);
  final UserModel user;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getCoursesProvider).when(
        data: (List<CourseModel> courses) {
      courses = courses
          .where((course) => user.courses!.contains(course.name))
          .toList();
      return DropdownButtonFormField<int>(
          decoration: InputDecoration(
              labelText: 'Select course',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
          value: ref.watch(_selectedCourse),
          items: courses
              .map((e) => DropdownMenuItem(
                    value: courses.indexOf(e),
                    child: Text(e.name),
                  ))
              .toList(),
          onChanged: (selectedCourse) {
            if (selectedCourse != null) {
              ref.watch(_selectedCourse.notifier).state = selectedCourse;
            }
          });
    }, error: (Object error, StackTrace stackTrace) {
      return const Center(
        child: Text("Error"),
      );
    }, loading: () {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    });
  }
}

class _DateWidget extends ConsumerWidget {
  const _DateWidget();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(_selectedDate) == null
        ? Padding(
            padding:
                const EdgeInsets.only(left: 15.0, right: 15, top: 8, bottom: 8),
            child: Card(
              child: ListTile(
                leading: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.calendar_month),
                ),
                onTap: () async {
                  var selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2023, 12, 31));

                  ref.watch(_selectedDate.notifier).state = selectedDate;
                },
                title: const Text("Select Date"),
                subtitle: const Text("No date selected"),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
            child: Card(
              child: ListTile(
                title: Text(
                    DateFormat.yMMMMEEEEd().format(ref.watch(_selectedDate)!)),
                trailing: IconButton(
                    onPressed: () {
                      ref.watch(_selectedDate.notifier).state = null;
                    },
                    icon: const Icon(Icons.cancel)),
              ),
            ),
          );
  }
}

class _TimeWidget extends ConsumerWidget {
  const _TimeWidget();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(_selectedTime) == null
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
            child: Card(
              child: ListTile(
                onTap: () async {
                  var selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  ref.watch(_selectedTime.notifier).state = selectedTime;
                },
                leading: const Padding(
                    padding: EdgeInsets.all(8), child: Icon(Icons.alarm)),
                title: const Text("Select Start Time"),
                subtitle: const Text("No time selected"),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
            child: Card(
              child: ListTile(
                title: Text((ref.watch(_selectedTime)!.format(context))),
                trailing: IconButton(
                    onPressed: () {
                      ref.watch(_selectedTime.notifier).state = null;
                    },
                    icon: const Icon(Icons.cancel)),
              ),
            ),
          );
  }
}

class _DurationWidget extends ConsumerWidget {
  const _DurationWidget();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
      child: TextField(
          keyboardType: TextInputType.number,
          onChanged: (duration) {
            duration.isNotEmpty
                ? ref.watch(_selectedDuration.notifier).state =
                    int.parse(duration)
                : null;
          },
          decoration: InputDecoration(
              hintText: 'Enter Duration in minutes',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)))),
    );
  }
}

final _selectedDuration = StateProvider.autoDispose<int?>((ref) => null);
final _selectedTime = StateProvider.autoDispose<TimeOfDay?>((ref) => null);
final _selectedDate = StateProvider.autoDispose<DateTime?>((ref) => null);
final _selectedQuizName = StateProvider<String>((ref) => '');
final _selectedCourse = StateProvider.autoDispose<int>((ref) => 0);
