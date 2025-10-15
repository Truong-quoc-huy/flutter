# Ứng dụng Quản lý Sinh viên

Dự án Flutter quản lý danh sách sinh viên trong lớp với Firebase Authentication và Firestore.

## Tính năng

- 🔐 Đăng nhập/Đăng ký với Firebase Authentication
- 👥 Quản lý danh sách sinh viên
- ➕ Thêm sinh viên mới
- ✏️ Sửa thông tin sinh viên
- 🗑️ Xóa sinh viên
- 🔍 Tìm kiếm sinh viên theo tên hoặc MSSV
- 📋 Lọc sinh viên theo lớp học
- 📱 Giao diện Material Design 3

## Cấu trúc dữ liệu Firestore

### Collection: students

```json
{
  "name": "string",           // Họ tên sinh viên
  "studentCode": "string",    // Mã số sinh viên (VD: KTPM20520001)
  "birthdate": "Timestamp",   // Ngày sinh
  "className": "string",      // Tên lớp (VD: CTK45)
  "gender": "string",         // "Nam" hoặc "Nữ"
  "gpa": "double",            // Điểm trung bình (tùy chọn)
  "phone": "string",          // Số điện thoại (tùy chọn)
  "createdAt": "Timestamp",   // Thời điểm thêm
  "updatedAt": "Timestamp"    // Thời điểm chỉnh sửa
}
```

## Cài đặt và chạy

### 1. Cài đặt Flutter
Đảm bảo bạn đã cài đặt Flutter SDK và Dart.

### 2. Cài đặt dependencies
```bash
flutter pub get
```

### 3. Cấu hình Firebase

#### Android:
1. Tạo project Firebase mới
2. Thêm Android app với package name: `com.example.truongquochuy`
3. Tải file `google-services.json` và đặt vào `android/app/`
4. Bật Authentication (Email/Password)
5. Bật Firestore Database

#### iOS:
1. Thêm iOS app vào Firebase project
2. Tải file `GoogleService-Info.plist` và đặt vào `ios/Runner/`
3. Cấu hình tương tự Android

### 4. Chạy ứng dụng
```bash
flutter run
```

## Cấu trúc dự án

```
lib/
├── main.dart                    # Entry point
├── models/
│   └── student.dart            # Model sinh viên
├── providers/
│   ├── auth_provider.dart       # Quản lý authentication
│   └── student_provider.dart   # Quản lý dữ liệu sinh viên
└── screens/
    ├── login_screen.dart        # Màn hình đăng nhập
    ├── home_screen.dart         # Màn hình chính
    └── add_edit_student_screen.dart # Thêm/sửa sinh viên
```

## Lưu ý

- Cần cấu hình Firebase project thực tế để sử dụng
- File `google-services.json` và `GoogleService-Info.plist` hiện tại chỉ là template
- Đảm bảo đã bật Authentication và Firestore trong Firebase Console
- Cấu hình Firestore rules để bảo mật dữ liệu

## Tác giả

Trương Quốc Huy - truongquochuy
