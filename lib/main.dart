import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:eleran/helpers/db.dart';
import 'package:eleran/providers/savequizprovider.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import 'firebase_options.dart';
import 'mainapp/admin/admin_landing.dart';
import 'mainapp/lecturer/lecturer_home.dart';
import 'mainapp/quiz_waiting_page.dart';
import 'mainapp/student/student_view.dart';
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
      FirebaseFunctions.instance..useFunctionsEmulator('192.168.25.127', 5001));
  FirebaseFirestore store = FirebaseFirestore.instance;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  GetIt.I.registerSingleton<FirebaseFirestore>(store);
  FirebaseFirestore.instance.useFirestoreEmulator('192.168.110.127', 8080);
  FirebaseDatabase.instance.useDatabaseEmulator('192.168.110.127', 9000);
  FirebaseAuth.instance.useAuthEmulator('192.168.110.127', 9099);
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
          var userID = FirebaseAuth.instance.currentUser?.uid;
          if (userID != null) {
            return FutureBuilder(
              builder: (context, data) {
                if (data.connectionState == ConnectionState.done) {
                  if (data.data != null) {
                    return MaterialApp(
                      home: QuizWaitingPageView(
                          quizID: event.data['quizId'], user: data.data!),
                    );
                  }
                  return Container();
                }

                return const MaterialApp(
                    home: Scaffold(
                        body: Center(
                            child: CircularProgressIndicator.adaptive())));
              },
              future: GetIt.I<Database>().getUserProfile(userID),
            );
          }
          return MyApp();
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
    );
  }
}

class ProfileDecider extends ConsumerWidget {
  const ProfileDecider({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(saveUserProfileProvider, (previous, next) {
      if (previous != next) {
        next.when(data: (data) {
          if (data == SaveProfileEnum.success) {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Succcess")));
            ref.invalidate(getUserProfile(id));
          }
        }, error: (e, st) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Error")));
        }, loading: () {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Saving...")));
        });
      }
    });
    return ref.watch(getUserProfile(id)).when(
        data: (data) {
          if (data != null) {
            return data.userType == UserType.student
                ? StudentView(
                    user: data,
                  )
                : data.userType == UserType.staff
                    ? LecturerHomePage(user: data)
                    : AdminView(user: data);
          }
          {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: const Text("Continue Registeration"),
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextFormField(
                          onChanged: (text) {
                            ref.watch(_userController.notifier).state = text;
                          },
                          decoration: InputDecoration(
                              labelText: 'Enter Your full name',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30))),
                        ),
                        DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            value: ref.watch(_selectedUserType),
                            items: const [
                              DropdownMenuItem(
                                  value: 'staff', child: Text("Staff")),
                              DropdownMenuItem(
                                  value: 'student', child: Text("Student")),
                              DropdownMenuItem(
                                  value: 'admin', child: Text("Admin")),
                            ],
                            onChanged: (selected) {
                              if (selected != null) {
                                ref.watch(_selectedUserType.notifier).state =
                                    selected;
                              }
                            }),
                        ref.watch(getCoursesProvider).when(
                            data: (courses) {
                              return Row(
                                children: courses
                                    .map((course) => Expanded(
                                          child: CheckboxListTile(
                                              value: ref
                                                  .watch(
                                                      _selectedCourseProvider)
                                                  .contains(course.name),
                                              title: Text(course.name),
                                              onChanged: (selected) => selected !=
                                                      null
                                                  ? ref
                                                      .watch(
                                                          _selectedCourseProvider
                                                              .notifier)
                                                      .update((state) {
                                                      state.contains(
                                                              course.name)
                                                          ? {
                                                              state.remove(
                                                                  course.name),
                                                              state = [...state]
                                                            }
                                                          : state
                                                              .add(course.name);
                                                      state = [...state];
                                                      return state;
                                                    })
                                                  : null),
                                        ))
                                    .toList(),
                              );
                            },
                            error: (er, st) =>
                                const Text("Error  loading courses"),
                            loading: () =>
                                const CircularProgressIndicator.adaptive()),
                        ElevatedButton(
                          onPressed: () {
                            var user = UserModel(
                                name: ref.watch(_userController),
                                id: id,
                                courses: ref.watch(_selectedUserType) == 'admin'
                                    ? null
                                    : ref.watch(_selectedCourseProvider),
                                userType: UserType.values.firstWhere(
                                    (element) =>
                                        describeEnum(element) ==
                                        ref.watch(_selectedUserType)));
                            ref
                                .watch(saveUserProfileProvider.notifier)
                                .saveProfile(user);
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              minimumSize: const Size(double.infinity, 60)),
                          child: const Text("Save Profile"),
                        ),
                        TextButton(
                            onPressed: () async {
                              FirebaseAuth.instance.signOut();
                              Navigator.pushReplacementNamed(
                                  context, '/sign-in');
                            },
                            child: const Text("logout"))
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
        error: (er, st) {
          debugPrintStack(stackTrace: st);
          return const Center(child: Text("Error"));
        },
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
      var userID = FirebaseAuth.instance.currentUser?.uid;
      if (userID != null) {
        return FutureBuilder(
          builder: (context, data) {
            if (data.connectionState == ConnectionState.done) {
              if (data.data != null) {
                return QuizWaitingPageView(quizID: quizId, user: data.data!);
              }
              return Container();
            }

            return const Center(child: CircularProgressIndicator.adaptive());
          },
          future: GetIt.I<Database>().getUserProfile(userID),
        );
      }
      return MyApp();
    }));
  }
}

BuildContext? contexter;

final getUserProfile =
    FutureProvider.family<UserModel?, String>((ref, id) async {
  return await GetIt.I<Database>().getUserProfile(id);
});
final _selectedUserType = StateProvider.autoDispose((ref) => 'student');

final getCoursesProvider = FutureProvider((ref) async {
  return await GetIt.I<Database>().getAllCourses();
});

final _selectedCourseProvider = StateProvider<List<String>>((ref) => []);
final getMessagingToken =
    FutureProvider.family<void, UserModel>((ref, user) async {
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
});
final _userController = StateProvider((ref) => '');
