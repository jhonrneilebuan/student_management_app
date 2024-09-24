import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/student.dart';

class StudentFormScreen extends StatefulWidget {
  const StudentFormScreen({super.key});

  @override
  StudentFormScreenState createState() => StudentFormScreenState();
}

class StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();
  String firstName = '';
  String lastName = '';
  String course = '';
  String? year;
  bool enrolled = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Student newStudent = Student(
        id: '',
        firstName: firstName,
        lastName: lastName,
        course: course,
        year: year ?? 'First Year',
        enrolled: enrolled,
      );

      try {
        await apiService.createStudent(newStudent); 
        if (mounted) { 
          Navigator.pushReplacementNamed(context, '/studentList');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to create student')),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Fill Student Information'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      width: 1,
                      color: Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the first name';
                          }
                          return null;
                        },
                        onSaved: (value) => firstName = value!,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the last name';
                          }
                          return null;
                        },
                        onSaved: (value) => lastName = value!,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Course',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the course';
                          }
                          return null;
                        },
                        onSaved: (value) => course = value!,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Year',
                          border: OutlineInputBorder(),
                        ),
                        value: year,
                        items: ['First Year', 'Second Year', 'Third Year', 'Fourth Year', 'Fifth Year']
                            .map((year) => DropdownMenuItem(
                                  value: year,
                                  child: Text(year),
                                ))
                            .toList(),
                        onChanged: (value) => setState(() => year = value),
                        validator: (value) => value == null ? 'Please select a year' : null,
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Enrolled'),
                        value: enrolled,
                        onChanged: (value) => setState(() => enrolled = value),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.blue, 
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
