import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class StudentQuizResultView extends ConsumerWidget {
  const StudentQuizResultView(
      {super.key,
      required this.correctAnswersLength,
      required this.totalQuestionsLength});
  final int correctAnswersLength;
  final int totalQuestionsLength;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Lottie.asset('animations/done.json',
                width: 250,
                height: 250,
                repeat: true,
                onLoaded: (compostion) => {}),
            Row(
              children: [
                Text("You scored",
                    style: GoogleFonts.anton(color: Colors.grey, fontSize: 40)),
                Text('$correctAnswersLength / $totalQuestionsLength',
                    style: GoogleFonts.anton(color: Colors.green, fontSize: 40))
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                  ..pop()
                  ..pop();
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60)),
              child: const Text("Go Back"),
            )
          ],
        ),
      ),
    ));
  }
}
