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
      title: 'Student Management', // Tinutukoy ang pamagat ng app na makikita sa task manager.
      debugShowCheckedModeBanner: false, // Inaalis ang debug banner na nasa top-right ng screen.
      initialRoute: '/studentList', // Ito ang unang screen na lalabas sa pagsisimula ng app.
      routes: {
        '/studentList': (context) => StudentListScreen(), // Nagbibigay ng ruta para sa StudentListScreen.
        '/studentForm': (context) => StudentFormScreen(), // Nagbibigay ng ruta para sa StudentFormScreen.
      },
    );
  }
}
