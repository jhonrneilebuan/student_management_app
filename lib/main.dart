import 'package:flutter/material.dart';
import 'screens/student_list_screen.dart';
import 'screens/student_form.dart';
void main() {
  runApp(const MyApp()); 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Management', 
      debugShowCheckedModeBanner: false, 
      initialRoute: '/studentList',
      routes: {
        '/studentList': (context) => const StudentListScreen(), // Nagbibigay ng ruta para sa StudentListScreen.
        '/studentForm': (context) => const StudentFormScreen(), // Nagbibigay ng ruta para sa StudentFormScreen.
      },
    );
  }
}
