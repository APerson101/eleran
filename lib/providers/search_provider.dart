import 'package:eleran/helpers/db.dart';
import 'package:eleran/models/quiz_model.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_provider.g.dart';

@riverpod
class SearchResult extends _$SearchResult {
  @override
  FutureOr<List<QuizModel>> build() {
    return [];
  }

  search(String course) async {
    state = const AsyncLoading();
    try {
      var searchResult =
          await GetIt.I<Database>().getAllPossibleQuiz(course: course);
      state = AsyncData(searchResult);
    } catch (e) {
      state = AsyncError('fd', StackTrace.current);
    }
  }
}
