import 'package:eleran/helpers/db.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../mainapp/student/student_view.dart';
import '../models/user_model.dart';
import 'countdownprovider.dart';

part 'savequizprovider.g.dart';

enum SaveQuizEnums { success, failure, idle }

@riverpod
class SaveQuiz extends _$SaveQuiz {
  @override
  FutureOr<SaveQuizEnums> build() {
    return SaveQuizEnums.idle;
  }

  saveAnswer(
      String quizID,
      List<bool> answers,
      String quizName,
      DateTime quizTaken,
      UserModel user,
      String userName,
      String userID) async {
    try {
      await GetIt.I<Database>().saveQuizAnswer(
          quizID, answers, quizName, quizTaken, userName, userID);
      state = const AsyncData(SaveQuizEnums.success);
      ref.watch(stopQuizProvider.notifier).state = QuizEndEnum.result;
      // refresh pending quiz and previous taken quiz
      ref.invalidate(getUserQuizHistory(user));
      ref.invalidate(getUpComingQuiz(user));
    } catch (e) {
      debugPrint(e.toString());
      state = const AsyncData(SaveQuizEnums.failure);
    }
  }
}

enum SaveProfileEnum { success, failure, idle }

@riverpod
class SaveUserProfile extends _$SaveUserProfile {
  @override
  FutureOr<SaveProfileEnum> build() {
    return (SaveProfileEnum.idle);
  }

  saveProfile(UserModel user) async {
    state = const AsyncValue.loading();
    try {
      await GetIt.I<Database>().saveUserProfile(user: user);
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      var key = await messaging.getToken();
      await GetIt.I<Database>().saveToken(key!, user);
      state = const AsyncData(SaveProfileEnum.success);
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }
}
