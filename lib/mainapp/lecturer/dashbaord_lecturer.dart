import 'package:eleran/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'create_quiz.dart';

class LecturerDashboard extends ConsumerWidget {
  const LecturerDashboard({super.key, required this.user});
  final UserModel user;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _LecturerDash(user: user);
  }
}

class _LecturerDash extends ConsumerWidget {
  const _LecturerDash({required this.user});
  final UserModel user;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return CreateQuizView(user: user);
              }));
            },
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60)),
            child: const Text("Create new quiz"),
          ),
        ),
      ),
    );
  }
}
