import 'package:flutter/material.dart';
import 'package:student_management_app/screens/student_viewform.dart';
import '../services/api_service.dart';
import '../models/student.dart';
import 'student_form.dart'; // Import the StudentFormScreen

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  StudentListScreenState createState() => StudentListScreenState();
}

class StudentListScreenState extends State<StudentListScreen> {
  ApiService apiService = ApiService(); // Instance of ApiService to handle API calls
  late Future<List<Student>> _futureStudents; // Future that will hold the list of students

  @override
  void initState() {
    super.initState();
    _futureStudents = apiService.getStudents(); // Initialize the future with the list of students from the API
  }

  // Function to refresh the list of students
  Future<void> _refreshStudents() async {
    setState(() {
      _futureStudents = apiService.getStudents(); // Re-fetch the list of students and update the UI
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable the default back button
        title: const Text('Student List'), 
        actions: [
          IconButton(
            icon: const Icon(Icons.add), // Icon to add a new student
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StudentFormScreen()), // Navigate to the StudentFormScreen when the add button is pressed
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Student>>(
        future: _futureStudents, // The future that contains the list of students
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Student> students = snapshot.data!; // Retrieve the list of students from the snapshot
            return RefreshIndicator(
              onRefresh: _refreshStudents, // Allow pull-to-refresh to update the list
              child: ListView.builder(
                itemCount: students.length, // Number of students to display
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text('${students[index].firstName} ${students[index].lastName}'), // Display the student's name
                      subtitle: Text('${students[index].course} - ${students[index].year}'), // Display the student's course and year
                      onTap: () async {
                        // When a student is tapped, navigate to the StudentViewForm to view details
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentViewForm(student: students[index]),
                          ),
                        );
                        if (result == true) {
                          _refreshStudents(); // If the user deleted a student, refresh the list
                        }
                      },
                    ),
                  );
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Display error if the API call fails
          }
          return const Center(child: CircularProgressIndicator()); // Show a loading spinner while fetching data
        },
      ),
    );
  }
}
