import 'package:flutter/material.dart';
import '../models/student.dart';
import 'student_detail_screen.dart';
import '../services/api_service.dart'; // Ensure ApiService is imported

class StudentViewForm extends StatefulWidget {
  final Student student;

  const StudentViewForm({required this.student});

  @override
  _StudentViewFormState createState() => _StudentViewFormState();
}

class _StudentViewFormState extends State<StudentViewForm> {
  final ApiService apiService = ApiService(); // Initialize ApiService
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
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Student Details'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshStudent, // Refresh function
        child: Container( height: 250,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.all(16.0),
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text(
                'First Name: ${student.firstName}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Last Name: ${student.lastName}',
                style: const TextStyle(fontSize: 18),
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
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            StudentDetailScreen(studentId: student.id),
                      ),
                    );
                  },
                  child: const Text('Update'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
