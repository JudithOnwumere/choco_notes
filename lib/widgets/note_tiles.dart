import 'dart:ui';

import 'package:choconotes/controllers/note_controller.dart';
import 'package:choconotes/screens/note_editor.dart';
import 'package:choconotes/styles/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NoteTile extends StatelessWidget {
  final int index;

  const NoteTile({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final NoteController controller = Get.find();
    final note = controller.filteredNotes[index]; // Use filteredNotes here
    final originalIndex = controller.notes.indexOf(note);
    final date = DateTime.tryParse(note['date'] ?? '') ?? DateTime.now();
    final formattedDate = DateFormat('dd MMMM yyyy, hh:mm a').format(date);

    return GestureDetector(
      onTap: () => Get.to(() => NoteEditor(index: originalIndex)),
      onLongPress: () => controller.confirmDeleteDialog(context, index),
      child: ClipRRect(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(color: Colors.black.withOpacity(0)),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                border: Border.all(width: 1, color: Colors.white),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      return Text(
                        note['title'] ?? '',
                        style: AppTextStyles.noteTitle.copyWith(
                          color: controller.getTextColor(),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    }),
                    const SizedBox(height: 8),
                    Obx(() {
                      return Text(
                        note['content'] ?? '',
                        style: AppTextStyles.noteContent.copyWith(
                          color: controller.getTextColor(),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      );
                    }),
                    const SizedBox(height: 8),
                    Obx(() {
                      return Text(
                        formattedDate,
                        style: AppTextStyles.noteDate.copyWith(
                          color: controller.getTextColor(),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}