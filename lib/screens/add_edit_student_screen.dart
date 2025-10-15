import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/student_provider.dart';
import '../models/student.dart';

class AddEditStudentScreen extends StatefulWidget {
  final Student? student;

  const AddEditStudentScreen({super.key, this.student});

  @override
  State<AddEditStudentScreen> createState() => _AddEditStudentScreenState();
}

class _AddEditStudentScreenState extends State<AddEditStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _studentCodeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _gpaController = TextEditingController();

  DateTime? _selectedBirthdate;
  String _selectedGender = 'Nam';
  String _selectedClassName = 'CNTT1';

  final List<String> _genderOptions = ['Nam', 'Nữ'];
  final List<String> _classOptions = [
    'CNTT1',
    'CNTT2',
    'CNTT3',
    'CNTT4',
    'KTPM5',
    'KTPM4',
    'KTPM3',
    'KTPM2',
    'KTPM1',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.student != null) {
      _nameController.text = widget.student!.name;
      _studentCodeController.text = widget.student!.studentCode;
      _phoneController.text = widget.student!.phone ?? '';
      _gpaController.text = widget.student!.gpa?.toString() ?? '';
      _selectedBirthdate = widget.student!.birthdate;
      _selectedGender = widget.student!.gender;
      _selectedClassName = widget.student!.className;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _studentCodeController.dispose();
    _phoneController.dispose();
    _gpaController.dispose();
    super.dispose();
  }

  Future<void> _selectBirthdate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthdate ?? DateTime(2000),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedBirthdate) {
      setState(() {
        _selectedBirthdate = picked;
      });
    }
  }

  Future<void> _saveStudent() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBirthdate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn ngày sinh'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final studentProvider =
        Provider.of<StudentProvider>(context, listen: false);

    final student = Student(
      id: widget.student?.id,
      name: _nameController.text.trim(),
      studentCode: _studentCodeController.text.trim(),
      birthdate: _selectedBirthdate!,
      className: _selectedClassName,
      gender: _selectedGender,
      gpa: _gpaController.text.isNotEmpty
          ? double.tryParse(_gpaController.text)
          : null,
      phone: _phoneController.text.trim().isNotEmpty
          ? _phoneController.text.trim()
          : null,
      createdAt: widget.student?.createdAt ?? DateTime.now(),
      updatedAt: widget.student != null ? DateTime.now() : null,
    );

    bool success;
    if (widget.student != null) {
      success = await studentProvider.updateStudent(student);
    } else {
      success = await studentProvider.addStudent(student);
    }

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.student != null
                ? 'Cập nhật sinh viên thành công'
                : 'Thêm sinh viên thành công',
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.student != null
                ? 'Cập nhật sinh viên thất bại'
                : 'Thêm sinh viên thất bại',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.student != null ? 'Sửa sinh viên' : 'Thêm sinh viên',
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Họ và tên *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập họ và tên';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _studentCodeController,
                decoration: const InputDecoration(
                  labelText: 'Mã số sinh viên *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập mã số sinh viên';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(
                  labelText: 'Giới tính *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.wc),
                ),
                items: _genderOptions.map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedGender = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedClassName,
                decoration: const InputDecoration(
                  labelText: 'Lớp học *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.class_),
                ),
                items: _classOptions.map((String className) {
                  return DropdownMenuItem<String>(
                    value: className,
                    child: Text(className),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedClassName = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _selectBirthdate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Ngày sinh *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    _selectedBirthdate != null
                        ? DateFormat('dd/MM/yyyy').format(_selectedBirthdate!)
                        : 'Chọn ngày sinh',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Số điện thoại',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (!RegExp(r'^[0-9+\-\s()]{10,15}$')
                        .hasMatch(value.replaceAll(' ', ''))) {
                      return 'Số điện thoại không hợp lệ';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _gpaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Điểm trung bình (GPA)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.grade),
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final gpa = double.tryParse(value);
                    if (gpa == null || gpa < 0 || gpa > 4) {
                      return 'GPA phải từ 0.0 đến 4.0';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveStudent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  widget.student != null ? 'Cập nhật' : 'Thêm sinh viên',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
