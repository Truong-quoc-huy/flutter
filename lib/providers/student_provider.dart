import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/student.dart';

class StudentProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Student> _students = [];
  List<Student> _filteredStudents = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedClass = 'Tất cả';
  String? _errorMessage;

  List<Student> get students => _filteredStudents;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get selectedClass => _selectedClass;
  String? get errorMessage => _errorMessage;

  List<String> get classNames {
    Set<String> classes = {'Tất cả'};
    for (var student in _students) {
      classes.add(student.className);
    }
    return classes.toList();
  }

  Future<void> fetchStudents() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      QuerySnapshot snapshot = await _firestore
          .collection('students')
          .orderBy('createdAt', descending: true)
          .get();

      _students =
          snapshot.docs.map((doc) => Student.fromFirestore(doc)).toList();

      _applyFilters();
    } catch (e) {
      _errorMessage = 'Không thể tải danh sách sinh viên: ${e.toString()}';
      debugPrint('Lỗi khi tải danh sách sinh viên: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addStudent(Student student) async {
    try {
      await _firestore.collection('students').add(student.toFirestore());
      await fetchStudents();
      return true;
    } catch (e) {
      debugPrint('Lỗi khi thêm sinh viên: $e');
      return false;
    }
  }

  Future<bool> updateStudent(Student student) async {
    try {
      await _firestore
          .collection('students')
          .doc(student.id)
          .update(student.copyWith(updatedAt: DateTime.now()).toFirestore());
      await fetchStudents();
      return true;
    } catch (e) {
      debugPrint('Lỗi khi cập nhật sinh viên: $e');
      return false;
    }
  }

  Future<bool> deleteStudent(String studentId) async {
    try {
      await _firestore.collection('students').doc(studentId).delete();
      await fetchStudents();
      return true;
    } catch (e) {
      debugPrint('Lỗi khi xóa sinh viên: $e');
      return false;
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void setSelectedClass(String className) {
    _selectedClass = className;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredStudents = _students.where((student) {
      bool matchesSearch = _searchQuery.isEmpty ||
          student.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          student.studentCode
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

      bool matchesClass =
          _selectedClass == 'Tất cả' || student.className == _selectedClass;

      return matchesSearch && matchesClass;
    }).toList();

    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
