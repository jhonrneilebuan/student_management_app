import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student.dart';

class ApiService {
  final String apiUrl = 'https://student-management-api-phi.vercel.app/api/students';

  Future<List<Student>> getStudents() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((json) => Student.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load students');
    }
  }

  Future<Student> getStudentById(String id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));
    if (response.statusCode == 200) {
      return Student.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load student');
    }
  }

  Future<void> createStudent(Student student) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'firstName': student.firstName,
        'lastName': student.lastName,
        'course': student.course,
        'year': student.year,
        'enrolled': student.enrolled,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create student');
    }
  }

  Future<void> updateStudent(Student student) async {
    final response = await http.put(
      Uri.parse('$apiUrl/${student.id}'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'firstName': student.firstName,
        'lastName': student.lastName,
        'course': student.course,
        'year': student.year,
        'enrolled': student.enrolled,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update student');
    }
  }

  Future<void> deleteStudent(String id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete student');
    }
  }
}
