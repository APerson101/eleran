import 'package:eleran/helpers/db.dart';
import 'package:eleran/mainapp/lecturer/quiz_questions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../helpers/enums.dart';

class CreateQuizView extends ConsumerWidget {
  const CreateQuizView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(sendFakeData).when(
        data: (_) => Scaffold(
              appBar: AppBar(),
              body: SafeArea(
                child: Form(
                  child: Column(children: [
                    const _DifficultyWidget(),
                    const _SelectCourseWidget(),
                    const _DateWidget(),
                    const _TimeWidget(),
                    const _DurationWidget(),
                    ElevatedButton(
                        onPressed: () {
                          // do some validation
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => QuizQuestionsCreatorView(
                                    quizDuration: ref.watch(_selectedDuration)!,
                                    difficulty: ref.watch(_selectedDifficulty),
                                    startDate: ref.watch(_selectedDate)!,
                                    startTime: ref.watch(_selectedTime)!,
                                    courses: ref.watch(_selectedCourses),
                                  )));
                        },
                        child: const Text("NEXT"))
                  ]),
                ),
              ),
            ),
        loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive())),
        error: (er, st) => const Scaffold(
            body: Center(child: Text("Failed to load fake data"))));
  }
}

class _SelectCourseWidget extends ConsumerWidget {
  const _SelectCourseWidget();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
            onPressed: () async {
              await showModalBottomSheet(
                isScrollControlled: true, // required for min/max child size
                context: context,
                builder: (ctx) {
                  return MultiSelectBottomSheet<CoursesListEnum>(
                    items: List<MultiSelectItem<CoursesListEnum>>.generate(
                        CoursesListEnum.values.length,
                        (index) => MultiSelectItem(
                            CoursesListEnum.values[index],
                            describeEnum(CoursesListEnum.values[index]))),
                    initialValue: const [],
                    onConfirm: (values) {
                      ref.watch(_selectedCourses.notifier).state = values;
                    },
                    maxChildSize: 0.8,
                  );
                },
              );
            },
            child: const Text('Select Related Courses')));
  }
}

class _DifficultyWidget extends ConsumerWidget {
  const _DifficultyWidget();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: QuizDifficulty.values
            .map((difficultylevel) => Expanded(
                  child: CheckboxListTile(
                      value: ref.watch(_selectedDifficulty) ==
                          QuizDifficulty.values.indexOf(difficultylevel),
                      title: Text(describeEnum(difficultylevel)),
                      onChanged: (selected) => selected != null && selected
                          ? ref.watch(_selectedDifficulty.notifier).state =
                              QuizDifficulty.values.indexOf(difficultylevel)
                          : null),
                ))
            .toList(),
      ),
    );
  }
}

class _DateWidget extends ConsumerWidget {
  const _DateWidget();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
        onPressed: () async {
          var selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2023, 12, 31));

          ref.watch(_selectedDate.notifier).state = selectedDate;
        },
        child: const Text("Select Date"));
  }
}

class _TimeWidget extends ConsumerWidget {
  const _TimeWidget();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
        onPressed: () async {
          var selectedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );

          ref.watch(_selectedTime.notifier).state = selectedTime;
        },
        child: const Text("Select Start Time"));
  }
}

class _DurationWidget extends ConsumerWidget {
  const _DurationWidget();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
        keyboardType: TextInputType.number,
        onChanged: (duration) {
          duration.isNotEmpty
              ? ref.watch(_selectedDuration.notifier).state =
                  int.parse(duration)
              : null;
        },
        decoration: const InputDecoration(
            hintText: 'Enter Duration in minutes',
            border: OutlineInputBorder()));
  }
}

final _selectedDuration = StateProvider.autoDispose<int?>((ref) => null);
final _selectedTime = StateProvider.autoDispose<TimeOfDay?>((ref) => null);
final _selectedDate = StateProvider.autoDispose<DateTime?>((ref) => null);
final _selectedDifficulty = StateProvider.autoDispose(((ref) => 0));
final _selectedCourses =
    StateProvider.autoDispose<List<CoursesListEnum>>((ref) => []);

final sendFakeData = FutureProvider((ref) async {
  return;
  await GetIt.I<Database>().createFakeData();
});
