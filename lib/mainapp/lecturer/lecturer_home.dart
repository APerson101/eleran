import 'package:eleran/mainapp/lecturer/dashbaord_lecturer.dart';
import 'package:eleran/mainapp/lecturer/profile_lecturer.dart';
import 'package:eleran/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'history_lecturer.dart';

class LecturerHomePage extends ConsumerWidget {
  const LecturerHomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(_currentIndex) == 0
          ? const LecturerDashboard()
          : ref.watch(_currentIndex) == 1
              ? LecturerHistoryView(
                  user: UserModel(
                      name: 'name',
                      id: '125bccfe-3f70-4189-ae1b-749c33174397',
                      userType: UserType.staff),
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
