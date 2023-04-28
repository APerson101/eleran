import 'package:eleran/mainapp/lecturer/dashbaord_lecturer.dart';
import 'package:eleran/mainapp/lecturer/profile_lecturer.dart';
import 'package:eleran/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'history_lecturer.dart';

class LecturerHomePage extends ConsumerWidget {
  const LecturerHomePage({super.key, required this.user});
  final UserModel user;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(_currentIndex) == 0
          ? LecturerDashboard(user: user)
          : ref.watch(_currentIndex) == 1
              ? LecturerHistoryView(
                  user: user,
                )
              : const LecturerProfileView(),
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          currentIndex: ref.watch(_currentIndex),
          onTap: (selected) {
            ref.watch(_currentIndex.notifier).state = selected;
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard), label: 'Dashboard'),
            BottomNavigationBarItem(
                icon: Icon(Icons.history), label: 'Results'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ]),
    );
  }
}

final _currentIndex = StateProvider((ref) => 0);
