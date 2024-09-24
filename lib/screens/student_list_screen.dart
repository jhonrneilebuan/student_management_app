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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Student List'), 
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StudentFormScreen()),
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
                itemCount: students.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text('${students[index].firstName} ${students[index].lastName}'),
                      subtitle: Text('${students[index].course} - ${students[index].year}'),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentViewForm(student: students[index]),
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
