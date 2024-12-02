import 'dart:ui';

import 'package:choconotes/styles/app_img_path.dart';
import 'package:choconotes/styles/app_strings.dart';
import 'package:choconotes/styles/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class NoteController extends GetxController {
  final storage = GetStorage();
  RxList<Map<String, String>> notes = <Map<String, String>>[].obs;
  RxList<Map<String, String>> filteredNotes =
      <Map<String, String>>[].obs; // For search results
  RxBool isGrid = false.obs;
  RxBool isDark = false.obs;
  var color = Colors.black;

  @override
  void onInit() {
    super.onInit();
    loadNotes();
    loadViewMode();
    loadTextColour();
    filteredNotes.assignAll(notes); // Initially show all notes
  }

  void loadNotes() {
    List? storedNotes = storage.read<List>('notes');
    if (storedNotes != null) {
      notes.value = storedNotes
          .map((e) => Map<String, String>.from(e as Map)) // Ensure correct type
          .toList();
      filteredNotes.assignAll(notes); // Update filteredNotes
    }
  }

  void searchNotes(String query) {
    if (query.isEmpty) {
      filteredNotes.assignAll(notes); // Reset to all notes if query is empty
    } else {
      filteredNotes.assignAll(
        notes.where((note) {
          final title = note['title']?.toLowerCase() ?? '';
          final content = note['content']?.toLowerCase() ?? '';
          return title.contains(query.toLowerCase()) ||
              content.contains(query.toLowerCase());
        }).toList(),
      );
    }
  }

  void addNote(String title, String content) {
    final date = DateTime.now().toIso8601String();
    notes.insert(0, {'title': title, 'content': content, 'date': date});
    saveNotes();
    searchNotes(''); // Update filteredNotes
  }

  void updateNote(int index, String title, String content) {
    final updatedNote = {
      'title': title,
      'content': content,
      'date': DateTime.now().toIso8601String(),
    };
    notes[index] = updatedNote;
    notes.insert(0, notes.removeAt(index)); // Move updated note to the top
    saveNotes();
    searchNotes(''); // Update filteredNotes
  }

  void deleteNote(int index) {
    notes.removeAt(index);
    saveNotes();
    searchNotes(''); // Update filteredNotes
  }

  void loadViewMode() {
    isGrid.value = storage.read<bool>('isGrid') ?? false;
  }

  void loadTextColour() {
    isDark.value = storage.read<bool>('isDark') ?? false;
  }

  Color getTextColor() {
    return isDark.value ? Colors.white : Colors.black;
  }

  Image logoMode() {
    return isDark.value
        ? Image.asset(AppImgPath.appNameImgDark)
        : Image.asset(AppImgPath.appNameImg);
  }

  void saveNotes() {
    storage.write('notes', notes);
  }

  void toggleView() {
    isGrid.value = !isGrid.value;
    storage.write('isGrid', isGrid.value);
  }

  void toggleColour() {
    isDark.value = !isDark.value;
    storage.write('isDark', isDark.value);
  }

  // Function to show a dialog
  void confirmDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      barrierColor: Colors.black12,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
          child: AlertDialog(
            backgroundColor: Colors.white.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(
                color: Colors.white.withOpacity(0.3),
                width: 1.0,
              ),
            ),
            title: const Text(AppStrings.deleteNoteTitle),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8.0), // Adjust the radius as needed
                        ),
                      ),
                      child: const Text(
                        AppStrings.cancelBtn,
                        style: AppTextStyles.alertBtn,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 24,
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        deleteNote(index);
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red.withOpacity(0.7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8.0), // Adjust the radius as needed
                        ),
                      ),
                      child: const Text(
                        AppStrings.deleteBtn,
                        style: AppTextStyles.alertBtn,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
