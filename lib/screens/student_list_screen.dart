import 'package:flutter/material.dart';
import 'package:student_management_app/screens/student_viewform.dart';
import '../services/api_service.dart';
import '../models/student.dart';
import 'student_form.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  StudentListScreenState createState() => StudentListScreenState();
}

class StudentListScreenState extends State<StudentListScreen> {
  ApiService apiService = ApiService();
  late Future<List<Student>> _futureStudents;

  @override
  void initState() {
    super.initState();
    _futureStudents = apiService.getStudents();
  }

  Future<void> _refreshStudents() async {
    setState(() {
      _futureStudents = apiService.getStudents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Student List',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.blueAccent),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const StudentFormScreen()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Student>>(
        future: _futureStudents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Student> students = snapshot.data!;
            return RefreshIndicator(
              onRefresh: _refreshStudents,
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                itemCount: students.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      title: Text(
                        '${students[index].firstName} ${students[index].lastName}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  '${students[index].course} - ${students[index].year}\n',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            ),
                            TextSpan(
                              text:
                                  'Enrolled: ${students[index].enrolled ? 'Yes' : 'No'}',
                              style: TextStyle(
                                fontSize: 14,
                                color: students[index].enrolled
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          color: Colors.grey, size: 16),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                StudentViewForm(student: students[index]),
                          ),
                        );
                        if (result == true) {
                          _refreshStudents();
                        }
                      },
                    ),
                  );
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
