import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'create_quiz.dart';

class LecturerDashboard extends ConsumerWidget {
  const LecturerDashboard({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const CreateQuizView();
  }
}
