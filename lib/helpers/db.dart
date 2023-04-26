import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:eleran/helpers/enums.dart';
import 'package:eleran/models/question_model.dart';
import 'package:eleran/models/quiz_history_model.dart';
import 'package:eleran/models/quiz_model.dart';
import 'package:eleran/models/user_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Database {
  FirebaseFirestore store = FirebaseFirestore.instance;
  FirebaseFunctions functions = FirebaseFunctions.instance;
  FirebaseDatabase database = FirebaseDatabase.instance;
  Database();
  Client client = Client();
  String tempToken = "";
  saveToken(String fcmtoken) async {
    // store.runTransaction((transaction) => transaction.)
    debugPrint("Saving token: $fcmtoken");

    tempToken = fcmtoken;
    return;
    return await store
        .collection('users')
        .doc('userID')
        .set({'fcmtoken': fcmtoken})
        .then((value) => true)
        .catchError((err) {
          debugPrint(err.toString());
          return false;
        });
  }

  notifyquizUpdate(List<CoursesListEnum> students) async {
    // get students to be notified
    debugPrint("Notifying students about created quiz");
    var studentsToBeNotified = await store
        .collection('users')
        .where('type', isEqualTo: 'student')
        .where('courses',
            arrayContainsAny:
                students.map((course) => describeEnum(course)).toList())
        .get()
        .then((value) => value);

    // get all their tokens
    var studentDocs = studentsToBeNotified.docs;
    List<String> allTokens = [];
    for (var studentDoc in studentDocs) {
      allTokens.add(studentDoc.get('fcmtoken'));
    }
    // send mass message to all the related users
    return await sendNotificationToTokens(allTokens);
  }

  Future<bool> sendNotificationToTokens(List<String> tokens) async {
    var callable = functions.httpsCallable('sendMessageToTokens');
    var result = await callable.call({
      'tokens': tokens,
    });
    return result.data as bool;
  }

  createFakeData() async {
    debugPrint("creating fake user data");

    await store.collection('users').add({
      'type': 'student',
      'courses': CoursesListEnum.values.map((e) => describeEnum(e)).toList(),
      'name': 'abdul-hadi hashim',
      'fcmtoken': tempToken
    });
  }

  fakeQuizData() async {
    debugPrint("creating fake quiz data");
    var quizCollection = store.collection('Quizzes');
    var quizzModel = QuizModel(
        creatorID: 'creatorID',
        quizName: 'Midterm 1',
        quizID: 'quizID',
        creatorName: 'Abba baba',
        allQuestions: List.generate(
            4,
            (index) => QuestionModel(
                question: 'question',
                correctAnswers: [true, true, false, false],
                options: ['optionsA', 'B', 'C', "D"])),
        createdDate: DateTime.now(),
        duration: 20,
        startDate: DateTime(2023, 4, 5),
        startTime: const TimeOfDay(hour: 14, minute: 00),
        relatedCourses: CoursesListEnum.values);
    var status = await quizCollection
        .add(quizzModel.toMap())
        .then((value) => 'SuccessFully Created New Quiz')
        .catchError((onError) => 'Failed to Create Quiz');
    return status;
  }

  saveQuizAnswer(String quizID, String studentID, List<bool> answers,
      String quizName, DateTime quizTaken) async {
    var ref = database.ref('quizzes/$quizID');
    await ref.set({studentID: answers});
    var quizHistory = QuizHistoryModel(
        quizName: quizName,
        answers: answers,
        quizID: quizID,
        quizTaken: quizTaken);
    (await store
        .collection('history/$studentID/quizHistory')
        .add(quizHistory.toMap()));
    /**
     * {
     * "quizzes": {
     * "QUIZID": {
     * "studentID": "
     * [0,1,2,3,4]
     * "
     * }
     * }
     * }
     */
  }

  getPending({required UserModel user}) async {
    var userQuizzes = (await store
            .collection('Quizzes')
            .where('courses',
                arrayContainsAny:
                    user.courses!.map((e) => describeEnum(e)).toList())
            .get())
        .docs;

    var pending = List.generate(userQuizzes.length,
        (index) => QuizModel.fromMap(userQuizzes[index].data()));
    pending = pending.where((quiz) {
      var start = quiz.startDate;
      var q = DateTime(start.year, start.month, start.day, quiz.startTime.hour,
              quiz.startTime.minute)
          .add(Duration(minutes: quiz.duration));
      return q.isAfter(DateTime.now());
    }).toList();
    var quizzes = await getUserQuizHistory(user);
    pending.removeWhere((pend) => quizzes
        .where((element) => element.quizID == pend.quizID)
        .toList()
        .isNotEmpty);
    return pending;
  }

  Future<List<QuizHistoryModel>> getUserQuizHistory(UserModel user) async {
    debugPrint(user.id);
    var historyDocs =
        (await store.collection('history/${user.id}/quizHistory').get()).docs;
    var data = List.generate(historyDocs.length,
        (index) => QuizHistoryModel.fromMap(historyDocs[index].data()));
    return data;
  }

  Future<List<QuizModel>> getAllPossibleQuiz(
      {required CoursesListEnum course}) async {
    var docs = (await store.collection('Quizzes').get()).docs;
    var allQuizzes = List.generate(
        docs.length, (index) => QuizModel.fromMap(docs[index].data()));
    allQuizzes = allQuizzes.where((quiz) {
      var start = quiz.startDate;
      var q = DateTime(start.year, start.month, start.day, quiz.startTime.hour,
              quiz.startTime.minute)
          .add(Duration(minutes: quiz.duration));
      return q.isBefore(DateTime.now());
    }).toList();
    return allQuizzes
        .where((element) => element.relatedCourses.contains(course))
        .toList();
  }
}
