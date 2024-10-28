import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/student.dart';

class StudentDetailScreen extends StatefulWidget {
  final String studentId;

  const StudentDetailScreen({required this.studentId, super.key});

  @override
  StudentDetailScreenState createState() => StudentDetailScreenState();
}

class StudentDetailScreenState extends State<StudentDetailScreen> {
  Student? student;
  bool isLoading = true;
  final ApiService apiService = ApiService();
  String? year;
  bool enrolled = false;

  @override
  void initState() {
    super.initState();
    _loadStudent();
  }

  Future<void> _loadStudent() async {
    try {
      final fetchedStudent = await apiService.getStudentById(widget.studentId);
      setState(() {
        student = fetchedStudent;
        year = student?.year ?? 'First Year';
        enrolled = student?.enrolled ?? false;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (student == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Student Details',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: const Center(
            child: Text('Failed to load student details.',
                style: TextStyle(color: Colors.black54))),
      );
    }

    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Student Details',
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: student!.firstName,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: 'First Name',
                  labelStyle: const TextStyle(color: Colors.black54),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) =>
                    student = student!.copyWith(firstName: value),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                initialValue: student!.lastName,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  labelStyle: const TextStyle(color: Colors.black54),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) =>
                    student = student!.copyWith(lastName: value),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                initialValue: student!.course,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: 'Course',
                  labelStyle: const TextStyle(color: Colors.black54),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) =>
                    student = student!.copyWith(course: value),
              ),
              const SizedBox(height: 16.0),
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
                          child: Text(year,
                              style: const TextStyle(color: Colors.black87)),
                        ))
                    .toList(),
                decoration: InputDecoration(
                  labelText: 'Year',
                  labelStyle: const TextStyle(color: Colors.black54),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) => setState(() => year = value),
              ),
              const SizedBox(height: 16.0),
              SwitchListTile(
                title: const Text('Enrolled',
                    style: TextStyle(color: Colors.black87)),
                value: enrolled,
                onChanged: (value) => setState(() => enrolled = value),
              ),
              const SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      student = student!.copyWith(
                        year: year ?? 'First Year',
                        enrolled: enrolled,
                      );
                      await apiService.updateStudent(student!);
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context, true);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
