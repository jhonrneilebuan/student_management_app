import 'package:flutter/material.dart';
import 'package:student_management_app/screens/student_viewform.dart';
import '../services/api_service.dart';
import '../models/student.dart';
import 'student_form.dart'; // Import the StudentFormScreen

class StudentListScreen extends StatefulWidget {
  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  ApiService apiService = ApiService();
  late Future<List<Student>> _futureStudents;

  @override
  void initState() {
    super.initState();
    _futureStudents = apiService.getStudents();
  }

  Future<void> _refreshStudents() async {
    setState(() {
      _futureStudents = apiService.getStudents(); // Refresh the data
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
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StudentFormScreen()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshStudents,
        child: FutureBuilder<List<Student>>(
          future: _futureStudents,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Student> students = snapshot.data!;
              return ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text('${students[index].firstName} ${students[index].lastName}'),
                      subtitle: Text('${students[index].course} - ${students[index].year}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentViewForm(student: students[index]),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
