import 'package:eleran/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentProfileView extends ConsumerWidget {
  const StudentProfileView({super.key, required this.user});
  final UserModel user;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: SizedBox.expand(
        child: Column(
          children: const [
            Text("AISHA SIBUWAYYYY"),
          ],
        ),
      ),
    );
  }
}
