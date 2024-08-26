// import 'package:flutter/material.dart';
// import 'package:student_management_app/screens/student_list_screen.dart';


// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Student Management',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: StudentListScreen(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'screens/student_list_screen.dart';
import 'screens/student_form.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/studentList',
      routes: {
        '/studentList': (context) => StudentListScreen(),
        '/studentForm': (context) => StudentFormScreen(),
      },
    );
  }
}
