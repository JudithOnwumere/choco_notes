import 'dart:io';
import 'dart:ui';

import 'package:choco_notes/styles/app_strings.dart';
import 'package:choco_notes/styles/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:choco_notes/controllers/bg_image_controller.dart';
import 'package:choco_notes/controllers/note_controller.dart';

class NoteEditor extends StatelessWidget {
  final BackgroundImageController bgcontroller =
      Get.put(BackgroundImageController());

  final int? index;

  NoteEditor({super.key, this.index});

  @override
  Widget build(BuildContext context) {
    final NoteController controller = Get.find();
    final titleController = TextEditingController(
        text: index != null ? controller.notes[index!]['title'] : '');
    final contentController = TextEditingController(
        text: index != null ? controller.notes[index!]['content'] : '');

    return Container(
        color: Colors.black,
        child: Obx(() {
          return Container(
            decoration: BoxDecoration(
              image: bgcontroller.backgroundImagePath.value.isNotEmpty
                  ? DecorationImage(
                      image: bgcontroller.backgroundImagePath.value
                              .startsWith('assets/')
                          ? AssetImage(bgcontroller.backgroundImagePath.value)
                              as ImageProvider // Default image
                          : FileImage(File(bgcontroller
                              .backgroundImagePath.value)), // Picked image
                      fit: BoxFit.cover,
                      opacity: 0.9,
                    )
                  : null,
            ),
            // ignore: deprecated_member_use
            child: WillPopScope(
              onWillPop: () async {
                final title = titleController.text.trim();
                final content = contentController.text.trim();

                if (title.isNotEmpty && content.isNotEmpty) {
                  if (index == null) {
                    controller.addNote(title, content);
                  } else {
                    controller.updateNote(index!, title, content);
                  }
                }
                return true;
              },
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    centerTitle: true,
                    title: Obx(() {
                      return controller.logoMode();
                    }),
                    actions: [
                      Obx(() {
                        return IconButton(
                            onPressed: () {
                              final title = titleController.text.trim();
                              final content = contentController.text.trim();
                              controller.shareNote(title, content);
                            },
                            icon: Icon(
                              Icons.share,
                              size: 26,
                              color: controller.getTextColor(),
                            ));
                      }),
                    ],
                    leading: Obx(() {
                      return IconButton(
                          onPressed: () {
                            final title = titleController.text.trim();
                            final content = contentController.text.trim();

                            if (title.isNotEmpty && content.isNotEmpty) {
                              if (index == null) {
                                controller.addNote(title, content);
                              } else {
                                controller.updateNote(index!, title, content);
                              }
                              Get.back();
                            } else {
                              Get.back();
                            }
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            size: 28,
                            color: controller.getTextColor(),
                          ));
                    }),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: titleController,
                          autofocus: true,
                          maxLines: 3,
                          minLines: 1,
                          style: AppTextStyles.addnoteTitle.copyWith(
                            color: controller.getTextColor(),
                          ),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0),
                            hintText: AppStrings.addNoteTitle,
                            hintStyle: AppTextStyles.addnoteTitle,
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: contentController,
                            textAlignVertical: TextAlignVertical.top,
                            style: AppTextStyles.addnoteContent.copyWith(
                              color: controller.getTextColor(),
                            ),
                            maxLines: null,
                            expands: true,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 12.0),
                              hintText: AppStrings.addNoteBody,
                              hintStyle: AppTextStyles.addnoteContent,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }));
  }
}
