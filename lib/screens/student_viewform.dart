import 'package:flutter/material.dart';
import '../models/student.dart';
import 'student_detail_screen.dart';
import '../services/api_service.dart';

class StudentViewForm extends StatefulWidget {
  final Student student;

  const StudentViewForm({super.key, required this.student});

  @override
  StudentViewFormState createState() => StudentViewFormState();
}

class StudentViewFormState extends State<StudentViewForm> {
  final ApiService apiService = ApiService();
  late Student student;

  @override
  void initState() {
    super.initState();
    student = widget.student;
  }

  Future<void> _refreshStudent() async {
    try {
      final updatedStudent = await apiService.getStudentById(student.id);
      setState(() {
        student = updatedStudent;
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<void> _deleteStudent() async {
    try {
      await apiService.deleteStudent(student.id);
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true);
            }),
        title: const Text('View Student Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              final confirm = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Delete'),
                    content: const Text(
                        'Are you sure you want to delete this student?'),
                    actions: [
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                      TextButton(
                        child: const Text('Delete'),
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                    ],
                  );
                },
              );
              if (confirm == true) {
                await _deleteStudent();
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshStudent,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(
                16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      width: 3,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  padding: const EdgeInsets.all(
                      20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'First Name: ${student.firstName}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Last Name: ${student.lastName}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Course: ${student.course}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Year: ${student.year}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enrolled: ${student.enrolled ? 'Yes' : 'No'}',
                        style: TextStyle(
                          fontSize: 18,
                          color: student.enrolled
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              StudentDetailScreen(studentId: student.id),
                        ),
                      );
                      if (result == true) {
                        _refreshStudent();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                    ),
                    child: const Text('Update Details'),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
