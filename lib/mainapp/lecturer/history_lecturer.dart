import 'package:eleran/helpers/db.dart';
import 'package:eleran/models/quiz_history_model.dart';
import 'package:eleran/models/quiz_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../models/user_model.dart';

class LecturerHistoryView extends ConsumerWidget {
  const LecturerHistoryView({super.key, required this.user});
  final UserModel user;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(_getLecturerQuizzes(user.id)).when(
        data: (quizzes) {
          //
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                  children: quizzes
                      .map((e) => ListTile(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return ResultPage(quiz: e);
                              }));
                            },
                            title: Text(e.quizName),
                            subtitle: Text(e.createdDate.toIso8601String()),
                          ))
                      .toList()),
            ),
          );
        },
        error: (er, st) {
          return const Scaffold(body: Center(child: Text("Eror")));
        },
        loading: () => const Scaffold(
              body: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ));
  }
}

class ResultPage extends ConsumerWidget {
  const ResultPage({super.key, required this.quiz});
  final QuizModel quiz;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(_getQuizStats(quiz)).when(data: (data) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child:
              SfDataGrid(source: ResultData(historydatarows: data), columns: [
            GridColumn(columnName: 'name', label: const Text("Student name")),
            GridColumn(columnName: 'score', label: const Text("Student score")),
            GridColumn(
                columnName: 'percentage', label: const Text("Percentage")),
          ]),
        ),
      );
    }, error: (Object error, StackTrace stackTrace) {
      return const Material(
        child: Text("Error"),
      );
    }, loading: () {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
    });
  }
}

final _getLecturerQuizzes =
    FutureProvider.family<List<QuizModel>, String>((ref, staffID) async {
  return await GetIt.I<Database>().getLecturerQuiz(id: staffID);
});

final _getQuizStats =
    FutureProvider.family<List<QuizHistoryModel>, QuizModel>((ref, map) async {
  return await GetIt.I<Database>()
      .getQuizStats(quizID: map.quizID, staffID: map.creatorID);
});

class ResultData extends DataGridSource {
  ResultData({required List<QuizHistoryModel> historydatarows}) {
    datarows = historydatarows
        .map((e) => DataGridRow(cells: [
              DataGridCell(columnName: 'name', value: e.userName),
              DataGridCell(
                  columnName: 'score',
                  value:
                      '${e.answers.where((element) => element).toList().length / e.answers.length}'),
              DataGridCell(
                  columnName: 'percentage',
                  value:
                      '${(e.answers.where((element) => element).toList().length / e.answers.length) * 100}'),
            ]))
        .toList();
  }
  List<DataGridRow> datarows = [];
  @override
  List<DataGridRow> get rows => datarows;
  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map((e) => Text(e.value)).toList());
  }
}
