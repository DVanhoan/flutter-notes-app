# 📝 Notes App (Flutter)

Một ứng dụng ghi chú đơn giản, đẹp mắt, hỗ trợ chế độ tối và nhiều tính năng tiện ích.  
Được viết bằng **Flutter (>=3.10)** với **Android V2 Embedding**.

---

## 🚀 Tính năng

✅ **Giao diện mượt mà** — UI hoạt hình nhẹ nhàng, tinh tế  
✅ **Dark mode / Light mode** — Tự động lưu trạng thái theme  
✅ **Đánh dấu quan trọng** — Đánh dấu và lọc các ghi chú quan trọng  
✅ **Tìm kiếm nhanh** — Tìm ghi chú theo tiêu đề hoặc nội dung  
✅ **Chỉnh sửa ghi chú** — Sửa nội dung và lưu lại  
✅ **Chia sẻ dễ dàng** — Chia sẻ ghi chú qua mọi ứng dụng hỗ trợ văn bản

---

## 🧱 Cấu hình môi trường

| Công cụ     | Phiên bản khuyến nghị   |
| ----------- | ----------------------- |
| Flutter SDK | `>=3.10.0`              |
| Dart        | `>=3.0.0`               |
| Android SDK | `compileSdkVersion 34`  |
| iOS         | `platform :ios, '12.0'` |

---

## Cấu trúc thư mục

```yaml
lib/
┣ data/
┃ ┣ models.dart
┃ ┗ theme.dart
┣ services/
┃ ┣ database.dart
┃ ┗ theme_preference.dart
┣ screens/
┃ ┣ home.dart
┃ ┣ view.dart
┃ ┗ edit.dart
┗ main.dart
```

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  # UI Icons
  outline_material_icons: ^1.0.2

  # Database
  sqflite: ^2.3.2
  path_provider: ^2.1.2

  # Date / Formatting
  intl: ^0.19.0

  # Shared Preferences (Dark Mode)
  shared_preferences: ^2.3.1

  # Sharing Text
  share_plus: ^7.2.2

  # URL Launcher (nếu cần mở link ngoài)
  url_launcher: ^6.3.0
```

## Screenshots

<img src="github_assets/edit.gif" height="800">
