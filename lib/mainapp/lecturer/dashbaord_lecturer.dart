import 'package:eleran/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'create_quiz.dart';

class LecturerDashboard extends ConsumerWidget {
  const LecturerDashboard({super.key, required this.user});
  final UserModel user;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const CreateQuizView();
  }
}
