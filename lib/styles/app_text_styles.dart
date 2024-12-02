import 'package:flutter/material.dart';

class AppTextStyles {
  AppTextStyles._();

  static const noteTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  static const noteContent = TextStyle(fontSize: 16, color: Colors.black);
  static const noteDate = TextStyle(fontSize: 14);
  static const searchText = TextStyle(fontSize: 14);
  static const addnoteTitle = TextStyle(fontSize: 28, color: Colors.black87);
  static const addnoteContent = TextStyle(fontSize: 18, color: Colors.black87);
  static const alertBtn = TextStyle(fontSize: 16, color: Colors.black);
  static const imgPickerAlertContent =
      TextStyle(fontSize: 16, color: Colors.black);
}
