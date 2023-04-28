import 'package:eleran/models/user_model.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentProfileView extends ConsumerWidget {
  const StudentProfileView({super.key, required this.user});
  final UserModel user;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: SizedBox.expand(
          child: ProfileScreen(
        providers: [EmailAuthProvider()],
        actions: [
          SignedOutAction((context) {
            Navigator.pushReplacementNamed(context, '/sign-in');
          }),
        ],
        children: [...user.courses!.map((e) => Text(describeEnum(e)))],
      )),
    );
  }
}
