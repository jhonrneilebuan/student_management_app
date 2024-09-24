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
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (student == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Student Details')),
        body: const Center(child: Text('Failed to load student details.')),
      );
    }

    final formKey = GlobalKey<FormState>();

    return Scaffold(
      resizeToAvoidBottomInset: true, 
      appBar: AppBar(
        title: const Text('Student Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0), 
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: student!.firstName,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => student = student!.copyWith(firstName: value),
              ),
              const SizedBox(height: 16.0), 
              TextFormField(
                initialValue: student!.lastName,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => student = student!.copyWith(lastName: value),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                initialValue: student!.course,
                decoration: const InputDecoration(
                  labelText: 'Course',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => student = student!.copyWith(course: value),
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
                ].map((year) => DropdownMenuItem(
                      value: year,
                      child: Text(year),
                    )).toList(),
                decoration: const InputDecoration(
                  labelText: 'Year',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() => year = value),
              ),
              const SizedBox(height: 16.0),
              SwitchListTile(
                title: const Text('Enrolled'),
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
                    foregroundColor: Colors.white, backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
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
