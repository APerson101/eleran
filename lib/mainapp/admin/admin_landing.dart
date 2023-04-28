import 'package:eleran/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'admin_dashboard.dart';
import 'admin_profile.dart';

class AdminView extends ConsumerWidget {
  const AdminView({super.key, required UserModel user});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(_selectedIndex) == 0
          ? AdminDashboard()
          : const AdminProfile(),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (value) => ref.watch(_selectedIndex.notifier).state = value,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard), label: 'Dashboard'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ]),
    );
  }
}

final _selectedIndex = StateProvider((ref) => 0);
