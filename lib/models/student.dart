class Student {
  final String id; // Unique identifier para sa bawat student.
  final String firstName; // Unang pangalan ng student.
  final String lastName; // Apelyido ng student.
  final String course; // Kurso na kinukuha ng student.
  final String year; // Taon ng pag-aaral (e.g., First Year, Second Year).
  final bool enrolled; // Boolean value na nagsasaad kung enrolled ang student.

  // Constructor para sa Student class.
  Student({
    this.id = '', // Default value para sa id kung wala pang na-assign.
    required this.firstName, // Kinakailangang may value ang firstName.
    required this.lastName, // Kinakailangang may value ang lastName.
    required this.course, // Kinakailangang may value ang course.
    required this.year, // Kinakailangang may value ang year.
    required this.enrolled, // Kinakailangang may value kung enrolled o hindi.
  });

  // Factory constructor para gumawa ng Student object mula sa JSON data.
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['_id'] ?? '', // Value ng id mula sa JSON, o empty string kung walang id.
      firstName: json['firstName'] ?? '', // Value ng firstName mula sa JSON, o empty string kung wala.
      lastName: json['lastName'] ?? '', // Value ng lastName mula sa JSON, o empty string kung wala.
      course: json['course'] ?? '', // Value ng course mula sa JSON, o empty string kung wala.
      year: json['year'] ?? '', // Value ng year mula sa JSON, o empty string kung wala.
      enrolled: json['enrolled'] ?? false, // Value ng enrolled mula sa JSON, o false kung wala.
    );
  }

  // Method para gumawa ng bagong Student object na may updated properties.
  Student copyWith({
    String? id, // Optional parameter para sa id.
    String? firstName, // Optional parameter para sa firstName.
    String? lastName, // Optional parameter para sa lastName.
    String? course, // Optional parameter para sa course.
    String? year, // Optional parameter para sa year.
    bool? enrolled, // Optional parameter para sa enrolled.
  }) {
    return Student(
      id: id ?? this.id, // Kung may bagong id, gamitin ito, kung wala, gamitin ang existing id.
      firstName: firstName ?? this.firstName, // Kung may bagong firstName, gamitin ito, kung wala, gamitin ang existing firstName.
      lastName: lastName ?? this.lastName, // Kung may bagong lastName, gamitin ito, kung wala, gamitin ang existing lastName.
      course: course ?? this.course, // Kung may bagong course, gamitin ito, kung wala, gamitin ang existing course.
      year: year ?? this.year, // Kung may bagong year, gamitin ito, kung wala, gamitin ang existing year.
      enrolled: enrolled ?? this.enrolled, // Kung may bagong enrolled status, gamitin ito, kung wala, gamitin ang existing enrolled status.
    );
  }
}
