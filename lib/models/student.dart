class Student {
  final String id;
  final String firstName;
  final String lastName;
  final String course;
  final String year;
  final bool enrolled;

  Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.course,
    required this.year,
    required this.enrolled,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['_id'] ?? '', // Provide default values if null
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      course: json['course'] ?? '',
      year: json['year'] ?? '',
      enrolled: json['enrolled'] ?? false, // Handle null for boolean
    );
  }

  // Add the copyWith method
  Student copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? course,
    String? year,
    bool? enrolled,
  }) {
    return Student(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      course: course ?? this.course,
      year: year ?? this.year,
      enrolled: enrolled ?? this.enrolled,
    );
  }
}
