import 'package:eleran/helpers/db.dart';
import 'package:eleran/main.dart';
import 'package:eleran/models/coursemodel.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'save_course_provider.g.dart';

enum SaveCourseStatus { idle, success, failure }

@riverpod
class SaveCourse extends _$SaveCourse {
  @override
  FutureOr<SaveCourseStatus> build() {
    return SaveCourseStatus.idle;
  }

  saveNewCourse(CourseModel course) async {
    try {
      await GetIt.I<Database>().saveNewCourse(course.toMap());
      ref.invalidate(getCoursesProvider);
      state = const AsyncData(SaveCourseStatus.success);
    } catch (e) {
      state = const AsyncData(SaveCourseStatus.failure);
    }
  }

  removeCourse(CourseModel course) async {
    try {
      await GetIt.I<Database>().removeCourse(course);
      ref.invalidate(getCoursesProvider);
      state = const AsyncData(SaveCourseStatus.success);
    } catch (e) {
      state = const AsyncData(SaveCourseStatus.failure);
    }
  }
}
