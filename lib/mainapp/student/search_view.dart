import 'package:eleran/mainapp/quiz_waiting_page.dart';
import 'package:eleran/models/coursemodel.dart';
import 'package:eleran/providers/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../main.dart';
import '../../models/quiz_model.dart';
import '../../models/user_model.dart';

class StudentSearchView extends ConsumerWidget {
  StudentSearchView({super.key, required this.user});
  final UserModel user;
  final DataGridController controller = DataGridController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox.expand(
          child: Column(
            children: [
              ref.watch(getCoursesProvider).when(data: (courses) {
                return Row(
                  children: courses.map((e) {
                    return Expanded(
                      child: RadioListTile<CourseModel>(
                          title: Text(e.name),
                          value: e,
                          groupValue: courses[ref.watch(_selectedValue)],
                          onChanged: (changed) {
                            ref.watch(_selectedValue.notifier).state =
                                courses.indexOf(changed!);
                            ref.watch(_selectedCourse.notifier).state = changed;
                          }),
                    );
                  }).toList(),
                );
              }, error: (Object error, StackTrace stackTrace) {
                return const Text("Error loading");
              }, loading: () {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              }),
              ElevatedButton(
                  onPressed: () async {
                    ref
                        .watch(searchResultProvider.notifier)
                        .search(ref.watch(_selectedCourse)!.name);
                  },
                  child: const Text("search")),
              ref.watch(searchResultProvider).when(data: (result) {
                return result.isNotEmpty
                    ? SfDataGrid(
                        controller: controller,
                        source: QuizSearchResult(models: result),
                        selectionMode: SelectionMode.single,
                        onSelectionChanged: (re, nc) async {
                          int currentRow = controller.selectedIndex;
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      QuizWaitingPageView(
                                                          user: user,
                                                          quizID:
                                                              result[currentRow]
                                                                  .quizID)));
                                        },
                                        child: const Text("yes")),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("no")),
                                  ],
                                  title: const Text("Start quiz?"),
                                );
                              });
                        },
                        columns: [
                            GridColumn(
                                columnName: 'Quiz Title',
                                label: const Text("Quiz Title")),
                            GridColumn(
                                columnName: 'Creator Name',
                                label: const Text("Creator")),
                          ])
                    : const Center(
                        child: Text("Search for quizzes under a course"));
              }, error: (Object error, StackTrace stackTrace) {
                return const Center(
                  child: Text("Failed to load"),
                );
              }, loading: () {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              })
            ],
          ),
        ),
      ),
    );
  }
}

final _selectedValue = StateProvider((ref) => 0);
final _selectedCourse = StateProvider<CourseModel?>((ref) => null);

class QuizSearchResult extends DataGridSource {
  QuizSearchResult({required List<QuizModel> models}) {
    dataGridRow = models.map((e) {
      return DataGridRow(cells: [
        DataGridCell(columnName: 'Quiz Title', value: e.quizName),
        DataGridCell(columnName: 'Creator', value: e.creatorName),
      ]);
    }).toList();
  }
  List<DataGridRow> dataGridRow = [];
  @override
  List<DataGridRow> get rows => dataGridRow;
  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map((e) => Text(e.value)).toList());
  }
}
