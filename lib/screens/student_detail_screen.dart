import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/student.dart';

class StudentDetailScreen extends StatefulWidget {
  final String studentId;

  StudentDetailScreen({required this.studentId, Key? key}) : super(key: key);

  @override
  _StudentDetailScreenState createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  Student? student; // Make student nullable
  bool isLoading = true;
  final ApiService apiService = ApiService();
  String? year;

  @override
  void initState() {
    super.initState();
    _loadStudent();
  }

  // Function to load student data from the API
  Future<void> _loadStudent() async {
    try {
      final fetchedStudent = await apiService.getStudentById(widget.studentId);
      setState(() {
        student = fetchedStudent; // Set the student object
        year = student?.year ?? 'First Year'; // Use default year if null
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading spinner while fetching data
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Handle case where student could not be loaded
    if (student == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Student Details')),
        body: const Center(child: Text('Failed to load student details.')),
      );
    }

    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      resizeToAvoidBottomInset: true, // Ensure content is not hidden by the keyboard
      appBar: AppBar(
        title: const Text('Student Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0), // Padding around the form
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First Name TextFormField
              TextFormField(
                initialValue: student!.firstName,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(), // Add border to the field
                ),
                onSaved: (value) => student = student!.copyWith(firstName: value ?? ''),
              ),
              const SizedBox(height: 16.0), // Spacing between fields

              // Last Name TextFormField
              TextFormField(
                initialValue: student!.lastName,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => student = student!.copyWith(lastName: value ?? ''),
              ),
              const SizedBox(height: 16.0),

              // Course TextFormField
              TextFormField(
                initialValue: student!.course,
                decoration: const InputDecoration(
                  labelText: 'Course',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => student = student!.copyWith(course: value ?? ''),
              ),
              const SizedBox(height: 16.0),

              // Year DropdownButtonFormField
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
                decoration: const InputDecoration(
                  labelText: 'Year',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() => year = value),
                onSaved: (value) => student = student!.copyWith(year: value ?? 'First Year'),
              ),
              const SizedBox(height: 16.0),

              // Enrolled SwitchListTile
              SwitchListTile(
                title: const Text('Enrolled'),
                value: student!.enrolled,
                onChanged: (value) => setState(() => student = student!.copyWith(enrolled: value)),
              ),
              const SizedBox(height: 20.0),

              // Update Button
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      if (year != null) {
                        student = student!.copyWith(year: year!);
                        await apiService.updateStudent(student!);
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please select a year')),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
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
