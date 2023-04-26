import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mainapp/mainapp.dart';

class SignInWidget extends ConsumerWidget {
  const SignInWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const Center(child: TextField()),
        const Center(child: TextField()),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => MainFakeApp()));
            },
            child: const Text("Login"))
      ],
    );
  }
}
