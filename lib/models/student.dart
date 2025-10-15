import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  final String? id;
  final String name;
  final String studentCode;
  final DateTime birthdate;
  final String className;
  final String gender;
  final double? gpa;
  final String? phone;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Student({
    this.id,
    required this.name,
    required this.studentCode,
    required this.birthdate,
    required this.className,
    required this.gender,
    this.gpa,
    this.phone,
    required this.createdAt,
    this.updatedAt,
  });

  factory Student.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Student(
      id: doc.id,
      name: data['name'] ?? '',
      studentCode: data['studentCode'] ?? '',
      birthdate: (data['birthdate'] as Timestamp).toDate(),
      className: data['className'] ?? '',
      gender: data['gender'] ?? '',
      gpa: data['gpa']?.toDouble(),
      phone: data['phone'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'studentCode': studentCode,
      'birthdate': Timestamp.fromDate(birthdate),
      'className': className,
      'gender': gender,
      'gpa': gpa,
      'phone': phone,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  Student copyWith({
    String? id,
    String? name,
    String? studentCode,
    DateTime? birthdate,
    String? className,
    String? gender,
    double? gpa,
    String? phone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      studentCode: studentCode ?? this.studentCode,
      birthdate: birthdate ?? this.birthdate,
      className: className ?? this.className,
      gender: gender ?? this.gender,
      gpa: gpa ?? this.gpa,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
