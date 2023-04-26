import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:eleran/helpers/db.dart';
import 'package:eleran/helpers/enums.dart';
import 'package:eleran/models/question_model.dart';
import 'package:eleran/models/quiz_model.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import 'authentication/signin.dart';
import 'firebase_options.dart';
import 'mainapp/quiz_waiting_page.dart';
import 'mainapp/take_quiz_view.dart';
import 'models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
    host: "10.10.1.62:8080",
    sslEnabled: false,
    persistenceEnabled: false,
  );
  GetIt.I.registerSingleton<FirebaseMessaging>(FirebaseMessaging.instance);
  GetIt.I.registerSingleton<FirebaseFunctions>(
      FirebaseFunctions.instance..useFunctionsEmulator('192.168.8.100', 5001));
  FirebaseFirestore store = FirebaseFirestore.instance;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  GetIt.I.registerSingleton<FirebaseFirestore>(store);
  FirebaseFirestore.instance.useFirestoreEmulator('192.168.8.100', 8080);
  FirebaseDatabase.instance.useDatabaseEmulator('192.168.8.100', 9000);
  FirebaseAuth.instance.useAuthEmulator('192.168.8.100', 9099);
  GetIt.I.registerSingleton<Database>(Database());

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('launch_background');
  await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(android: initializationSettingsAndroid),
      onDidReceiveNotificationResponse: (response) =>
          foregroundNotificationHander(response, null));

  // what should happen when a message is received when the user is in the background
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestPermission();
  // FirebaseMessaging.onMessage.listen((message) {
  //   debugPrint("we are here attending to the rubbis");
  //   RemoteNotification? notification = message.notification;
  //   AndroidNotification? android = message.notification?.android;
  //   const cnl = AndroidNotificationChannel(
  //     'high_importance_channel', // id
  //     'High Importance Notifications', // title
  //     description:
  //         'This channel is used for important notifications.', // description
  //     importance: Importance.max,
  //   );
  //   var dets = AndroidNotificationDetails(cnl.id, cnl.name,
  //       channelDescription: cnl.description,
  //       importance: Importance.max,
  //       priority: Priority.high,
  //       ticker: 'ticker');
  //   if (notification != null && android != null) {
  //     flutterLocalNotificationsPlugin.show(
  //         notification.hashCode,
  //         notification.title,
  //         notification.body,
  //         NotificationDetails(android: dets),
  //         payload: message.data.toString());
  //   }
  // });
  // GetIt.I.registerSingleton<FlutterLocalNotificationsPlugin>(
  //     flutterLocalNotificationsPlugin);
  var data = (await messaging.getInitialMessage());
  runApp(ProviderScope(child: MainTestApp(initialData: data)));
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   GetIt.I.registerSingleton(Database());
//   FirebaseDatabase.instance.useDatabaseEmulator('192.168.8.101', 9000);
//   FirebaseFirestore.instance.useFirestoreEmulator('192.168.8.101', 8080);
//   FirebaseFunctions.instance.useFunctionsEmulator('192.168.8.101', 5001);

//   runApp(const ProviderScope(child: MyAppTest()));
// }

class MyAppTest extends StatelessWidget {
  const MyAppTest({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: TakeQuizView(
      user: UserModel(
        id: 'aisha',
        name: "Aisha sibuway",
        courses: CoursesListEnum.values,
        userType: UserType.student,
      ),
      quiz: QuizModel(
          quizName: 'hello world',
          creatorID: 'creatorID',
          quizID: 'quizID',
          allQuestions: List.generate(
              5,
              (index) => QuestionModel(
                      question: ' question $index',
                      correctAnswers: [
                        true,
                        true,
                        false,
                        false
                      ],
                      options: [
                        'hello world',
                        'how are you',
                        'where are you ',
                        'it is me'
                      ])),
          createdDate: DateTime.now(),
          duration: 2,
          startDate: DateTime.now(),
          startTime: const TimeOfDay(hour: 14, minute: 00),
          relatedCourses: [CoursesListEnum.comp103],
          creatorName: 'Musa farouq'),
    ));
    // return const MaterialApp(home: CreateQuizView());
  }
}

class MainTestApp extends StatelessWidget {
  MainTestApp({
    super.key,
    this.initialData,
  });
  RemoteMessage? initialData;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyApp(initialData: initialData));
  }
}

class MyApp extends StatelessWidget {
  MyApp({super.key, this.initialData});
  RemoteMessage? initialData;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    contexter = context;
    if (initialData != null) {
      foregroundNotificationHander(null, initialData);
    }
    FirebaseMessaging.onMessage.listen(showNotification);

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      debugPrint("hello world ");
      if (event.data['type'] == 'new-quiz-added') {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return MaterialApp(
              home: QuizWaitingPageView(
            quizID: event.data['quizId'],
            user: UserModel(
              id: 'aisha',
              name: "Aisha sibuway",
              courses: CoursesListEnum.values,
              userType: UserType.student,
            ),
          ));
        }));
      } else {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return MaterialApp(
              home: Center(
                  child: Scaffold(
                      appBar: AppBar(),
                      body: const Center(
                        child: Text(
                            "Hello, you tapped me from the backgroud right?"),
                      ))));
        }));
      }
    });

    return MaterialApp(
        initialRoute:
            FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/profile',
        routes: {
          '/sign-in': (context) {
            return SignInScreen(
              providers: [EmailAuthProvider()],
              actions: [
                AuthStateChangeAction<SignedIn>((context, state) {
                  Navigator.pushReplacementNamed(context, '/profile');
                }),
              ],
            );
          },
          '/profile': (context) {
            var user = FirebaseAuth.instance.currentUser!;
            return ProfileDecider(
              id: user.uid,
            );
          },
        },
        home: const SignInWidget()
        // home: StudentView(
        //   user: UserModel(
        //       courses: [CoursesListEnum.phy111, CoursesListEnum.comp103],
        //       name: 'Aisha Bamanga Tukur',
        //       id: '4421',
        //       userType: UserType.student),
        // ),
        );
  }
}

class ProfileDecider extends ConsumerWidget {
  const ProfileDecider({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(_getUserProfile(id)).when(
        data: (data) {
          if (data == null) {
            return Center(
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Enter name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30))),
                  )
                ],
              ),
            );
          }
          {
            return ProfileScreen(
              providers: [EmailAuthProvider()],
              actions: [
                SignedOutAction((context) {
                  Navigator.pushReplacementNamed(context, '/sign-in');
                }),
              ],
            );
          }
        },
        error: (er, st) => const Center(child: Text("Error")),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()));
  }
}

void showNotification(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  const cnl = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.max,
  );
  var dets = AndroidNotificationDetails(cnl.id, cnl.name,
      channelDescription: cnl.description,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker');
  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(android: dets),
        payload: message.data.toString());
  }
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void foregroundNotificationHander(
    NotificationResponse? respose, RemoteMessage? intialData) async {
  if (contexter == null) {
    debugPrint("cant help still null");
  } else {
    if (intialData != null) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    Navigator.of(contexter!).push(MaterialPageRoute(builder: (context) {
      String quizId = '';
      if (respose != null) {
        debugPrint('the response is');
        var payload = respose.payload!;
        var texts = payload.split(':');
        quizId = texts[1].split(',')[0].trim();
        debugPrint(quizId);
      } else {
        quizId = intialData?.data['quizId'];
      }
      return QuizWaitingPageView(
        quizID: quizId,
        user: UserModel(
          id: 'aisha',
          name: "Aisha sibuway",
          courses: CoursesListEnum.values,
          userType: UserType.student,
        ),
      );
    }));
  }
}

BuildContext? contexter;

final _getUserProfile =
    FutureProvider.family<UserModel?, String>((ref, id) async {
  return await GetIt.I<Database>().getUserProfile(id);
});
