import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:eleran/models/quiz_history_model.dart';
import 'package:eleran/models/quiz_model.dart';
import 'package:eleran/models/user_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../models/coursemodel.dart';

class Database {
  FirebaseFirestore store = FirebaseFirestore.instance;
  FirebaseFunctions functions = FirebaseFunctions.instance;
  FirebaseDatabase database = FirebaseDatabase.instance;
  Database();
  Client client = Client();
  String tempToken = "";
  saveToken(String fcmtoken, UserModel user) async {
    var id = (await store
            .collection('users')
            .where('id', isEqualTo: user.id)
            .limit(1)
            .get())
        .docs[0]
        .id;
    (await store
        .doc('users/$id')
        .update({'fcmtoken': fcmtoken})
        .then((value) => true)
        .catchError((err) {
          debugPrint(err.toString());
          return false;
        }));
  }

  notifyquizUpdate(List<String> students) async {
    // get students to be notified
    debugPrint("Notifying students about created quiz");
    var studentsToBeNotified = await store
        .collection('users')
        .where('type', isEqualTo: 'student')
        .where('courses',
            arrayContainsAny: students.map((course) => course).toList())
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

  saveQuizAnswer(
      String quizID,
      String studentID,
      List<bool> answers,
      String quizName,
      DateTime quizTaken,
      String userName,
      String userID) async {
    var ref = database.ref('Quizzes/$quizID');
    await ref.set({studentID: answers});
    var quizHistory = QuizHistoryModel(
        quizName: quizName,
        answers: answers,
        userID: userName,
        userName: userID,
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

  Future<List<QuizModel>> getAllPossibleQuiz({required String course}) async {
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

  Future<List<QuizModel>> getLecturerQuiz({required String id}) async {
    var docs = (await store
            .collection('Quizzes')
            .where('creatorID', isEqualTo: id)
            .get())
        .docs;
    return List.generate(
        docs.length, (index) => QuizModel.fromMap(docs[index].data()));
  }

  Future<List<QuizHistoryModel>> getQuizStats(
      {required String quizID, required staffID}) async {
    List<String> staffQuizID = [];
    var docs = (await store
            .collection('Quizzes')
            .where('creatorID', isEqualTo: staffID)
            .get())
        .docs;
    for (var doc in docs) {
      staffQuizID.add(doc.get('quizID'));
    }

    var hist = (await store
            .collection('history')
            .where('creatorID', whereIn: staffQuizID)
            .get())
        .docs;
    return List.generate(
        hist.length, (index) => QuizHistoryModel.fromMap(hist[index].data()));
  }

  Future<UserModel?>? getUserProfile(String id) async {
    var doc = (await store
            .collection('users')
            .where('id', isEqualTo: id)
            .limit(1)
            .get())
        .docs;
    if (doc.isNotEmpty) {
      return UserModel.fromMap(doc[0].data());
    }
    return null;
  }

  Future<List<CourseModel>> getAllCourses() async {
    var data = (await store.collection('courses').get()).docs;

    if (data.isNotEmpty) {
      List<CourseModel> courses = [];
      for (var course in data) {
        courses.add(CourseModel.fromMap(course.data()));
      }
      return courses;
    }
    return [];
  }

  saveUserProfile({required UserModel user}) async {
    (await store.collection('users').add(user.toMap()));
  }

  saveNewCourse(Map<String, dynamic> map) async {
    (await store.collection('courses').add(map));
  }

  removeCourse(CourseModel course) async {
    var docID = (await store
            .collection('courses')
            .where('name', isEqualTo: course.name)
            .limit(1)
            .get())
        .docs[0]
        .id;

    (await store.doc('courses/$docID').delete());
  }
}
