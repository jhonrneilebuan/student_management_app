import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/student.dart';

class StudentFormScreen extends StatefulWidget {
  @override
  _StudentFormScreenState createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>(); // Key para sa Form widget
  final ApiService apiService = ApiService(); // Service para sa API calls
  String firstName = ''; // Variable para sa first name
  String lastName = ''; // Variable para sa last name
  String course = ''; // Variable para sa course
  String? year; // Variable para sa year (pwedeng null)
  bool enrolled = false; // Variable para sa enrollment status

  // Function para i-submit ang form
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) { // Suriin kung valid ang form
      _formKey.currentState!.save(); // I-save ang mga value ng form

      Student newStudent = Student(
        id: '', // Ang ID ay auto-generated ng backend
        firstName: firstName,
        lastName: lastName,
        course: course,
        year: year ?? 'First Year', // Default year kung null
        enrolled: enrolled,
      );

      try {
        await apiService.createStudent(newStudent); // I-create ang student gamit ang API
        if (mounted) { // Siguraduhin na ang widget ay nakikita pa
          Navigator.pushReplacementNamed(context, '/studentList'); // I-navigate pabalik sa list screen
        }
      } catch (e) {
        // I-handle ang error kung may mangyaring problema
        print('Failed to create student: $e'); // I-print ang error sa console
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create student')), // Ipakita ang error sa user
          );
        }
      }
    }
  }

  @override
  void dispose() {
    // Linisin ang mga resources kung kinakailangan
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Siguraduhin na hindi matakpan ng keyboard ang content
      appBar: AppBar(
        title: const Text('Fill Student Information'), // Title ng AppBar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding sa paligid ng form
          child: Form(
            key: _formKey, // I-bind ang form key sa Form widget
            child: Column(
              children: [
                Container(
                  width: double.infinity, // Full width container
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      width: 1,
                      color: Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(16.0), // Padding sa loob ng container
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'First Name', // Label para sa first name field
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the first name'; // Error message kung walang input
                          }
                          return null;
                        },
                        onSaved: (value) => firstName = value!, // I-save ang first name
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
                        onSaved: (value) => lastName = value!, // I-save ang last name
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
                        onSaved: (value) => course = value!, // I-save ang course
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
                        onChanged: (value) => setState(() => year = value), // I-update ang year
                        validator: (value) => value == null ? 'Please select a year' : null,
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Enrolled'),
                        value: enrolled,
                        onChanged: (value) => setState(() => enrolled = value), // I-update ang enrollment status
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm, // I-submit ang form kapag pinindot
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.blue, // Kulay ng text
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
