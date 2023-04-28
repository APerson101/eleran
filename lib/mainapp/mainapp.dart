import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../models/user_model.dart';

class MainApp extends ConsumerWidget {
  const MainApp({super.key, required this.userModel});
  final UserModel userModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch(getMessage).when(
    //     data: (data) {
    //       if (data != null) {
    //         debugPrint(data.data.toString());
    //         // return;
    //         if (data.data['topic'] == 'new quiz ready') {
    //           Navigator.push(context,
    //               MaterialPageRoute(builder: (context) => const TestPage()));
    //         }
    //       }
    //     },
    //     error: (Object error, StackTrace stackTrace) {},
    //     loading: () {});

    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () async {
              var notification = GetIt.I<FlutterLocalNotificationsPlugin>();
              await notification.show(
                  0,
                  'New quiz',
                  'New quiz has been added',
                  const NotificationDetails(
                      android: AndroidNotificationDetails(
                          'channelId', 'channelName',
                          importance: Importance.max,
                          priority: Priority.high,
                          ticker: 'ticker')),
                  payload: 'test-');
            },
            child: const Text("Show notification")),
        Center(
            child: ElevatedButton(
                onPressed: () async {
                  // get messaging permission
                  // set up fake data
                  // 1. quiz

                  //send notification to user
                  // await GetIt.I<Database>()
                  //     .notifyquizUpdate(CoursesListEnum.values);
                },
                child: const Text("Run test"))),
      ],
    ));
  }
}

final getMessage = FutureProvider<RemoteMessage?>((ref) async {
  return await FirebaseMessaging.instance.getInitialMessage();
});
