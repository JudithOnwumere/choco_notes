import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:choconotes/screens/note_app.dart';

void main() async {
  await GetStorage.init();
  runApp(const ChocoNotes());
}

class ChocoNotes extends StatelessWidget {
  const ChocoNotes({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Choco Notes',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: NoteApp(),
    );
  }
}
