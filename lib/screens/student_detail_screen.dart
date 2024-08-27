import 'package:flutter/material.dart';
import 'package:student_management_app/screens/student_list_screen.dart';
import '../services/api_service.dart';
import '../models/student.dart';

class StudentDetailScreen extends StatefulWidget {
  final String studentId;

  StudentDetailScreen({required this.studentId, Key? key}) : super(key: key);

  @override
  _StudentDetailScreenState createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  late Student student;
  bool isLoading = true;
  final ApiService apiService = ApiService();
  String? year;

  @override
  void initState() {
    super.initState();
    _loadStudent();
  }

  Future<void> _loadStudent() async {
    try {
      student = await apiService.getStudentById(widget.studentId);
      setState(() {
        year = student.year;  
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final _formKey = GlobalKey<FormState>();

    // Ensure `year` has a default value from the options
    if (year == null || !['First Year', 'Second Year', 'Third Year', 'Fourth Year', 'Fifth Year'].contains(year)) {
      year = 'First Year'; // Provide a default value from the options
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Student Details')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: student.firstName,
                  decoration: const InputDecoration(labelText: 'First Name'),
                  onSaved: (value) => student = student.copyWith(firstName: value!),
                ),
                TextFormField(
                  initialValue: student.lastName,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                  onSaved: (value) => student = student.copyWith(lastName: value!),
                ),
                TextFormField(
                  initialValue: student.course,
                  decoration: const InputDecoration(labelText: 'Course'),
                  onSaved: (value) => student = student.copyWith(course: value!),
                ),
                DropdownButtonFormField<String>(
                  value: year,
                  items: [
                    'First Year',
                    'Second Year',
                    'Third Year',
                    'Fourth Year',
                    'Fifth Year'
                  ]
                  .map((year) => DropdownMenuItem(
                        value: year,
                        child: Text(year),
                      ))
                  .toList(),
                  decoration: const InputDecoration(labelText: 'Year'),
                  onChanged: (value) => setState(() => year = value),
                  onSaved: (value) => student = student.copyWith(year: value!),
                ),
                SwitchListTile(
                  title: const Text('Enrolled'),
                  value: student.enrolled,
                  onChanged: (value) => setState(() => student = student.copyWith(enrolled: value)),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      if (year != null) {
                        student = student.copyWith(year: year!);
                        await apiService.updateStudent(student);
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please select a year')),
                        );
                      }
                    }
                  },
                  child: const Text('Update'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await apiService.deleteStudent(student.id);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => StudentListScreen()),
                      (route) => false, // This removes all previous routes
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Delete'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
