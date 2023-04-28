import 'package:eleran/main.dart';
import 'package:eleran/mainapp/admin/providers/save_course_provider.dart';
import 'package:eleran/models/coursemodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminDashboard extends ConsumerWidget {
  AdminDashboard({super.key});
  final newCourseNameControler = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(saveCourseProvider, (pr, nx) {
      if (pr != nx) {
        nx.when(
            data: (data) {
              if (data == SaveCourseStatus.success) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text("Success!!")));
              } else {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text("Failed")));
              }
            },
            error: (er, st) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text("Failed")));
            },
            loading: () => ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Updating....."))));
      }
    });
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.all(20),
      child: ref.watch(getCoursesProvider).when(data: (courses) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              courses.isEmpty
                  ? const Text("No courses added yet!")
                  : const SizedBox(
                      height: 0,
                    ),
              ...List.generate(
                  courses.length,
                  (index) => ListTile(
                        title: Text(courses[index].name),
                        trailing: IconButton(
                            onPressed: () async {
                              // remove this course
                              await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text(
                                          "Are you sure you want to delete this course?"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              ref
                                                  .watch(saveCourseProvider
                                                      .notifier)
                                                  .removeCourse(courses[index]);
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Continue")),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Cancel")),
                                      ],
                                    );
                                  });
                            },
                            icon: const Icon(Icons.cancel)),
                      )),
              ElevatedButton(
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    ref
                                        .watch(saveCourseProvider.notifier)
                                        .saveNewCourse(CourseModel(
                                            name: newCourseNameControler.text,
                                            dateAdded: DateTime.now()));
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("continue")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("cancel")),
                            ],
                            content: SizedBox(
                              height: 75,
                              width: 150,
                              child: TextFormField(
                                controller: newCourseNameControler,
                                decoration: InputDecoration(
                                    labelText: 'Enter course code',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30))),
                              ),
                            ),
                          );
                        });
                  },
                  child: const Text('Enter new course'))
            ],
          ),
        );
      }, error: (er, st) {
        return const Text("Error fetching courses");
      }, loading: () {
        return const CircularProgressIndicator.adaptive();
      }),
    ));
  }
}
