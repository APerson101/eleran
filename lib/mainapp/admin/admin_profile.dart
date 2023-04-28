import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminProfile extends ConsumerWidget {
  const AdminProfile({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProfileScreen(providers: [
      EmailAuthProvider()
    ], actions: [
      SignedOutAction((context) {
        Navigator.pushReplacementNamed(context, '/sign-in');
      }),
    ]);
  }
}
