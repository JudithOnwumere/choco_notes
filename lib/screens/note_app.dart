import 'dart:io';

import 'package:choconotes/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:choconotes/controllers/bg_image_controller.dart';
import 'package:choconotes/controllers/note_controller.dart';
import 'package:choconotes/screens/note_editor.dart';
import 'package:choconotes/styles/linear_gradient.dart';
import 'package:choconotes/widgets/note_tiles.dart';

class NoteApp extends StatelessWidget {
  final BackgroundImageController bgcontroller =
      Get.put(BackgroundImageController());

  NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    final NoteController controller = Get.put(NoteController());

    return Container(
        decoration: BoxDecoration(
          gradient: gradient,
        ),
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
                      opacity: 0.7,
                    )
                  : null,
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() {
                      return controller.logoMode();
                    }),
                    Row(
                      children: [
                        IconButton(
                          icon: Obx(() => Icon(
                                controller.isGrid.value
                                    ? Icons.splitscreen
                                    : Icons.grid_view,
                                size: 28,
                                color: controller.getTextColor(),
                              )),
                          onPressed: () => controller.toggleView(),
                        ),
                        Obx(() {
                          return IconButton(
                              onPressed: () {
                                controller.toggleColour();
                              },
                              icon: Icon(
                                Icons.contrast,
                                size: 28,
                                color: controller.getTextColor(),
                              ));
                        }),
                        Obx(() {
                          return IconButton(
                            onPressed: () =>
                                bgcontroller.showImageOptionsDialog(context),
                            icon: Icon(
                              Icons.wallpaper,
                              size: 28,
                              color: controller.getTextColor(),
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const AppSearchBar(),
                    Expanded(
                      child: Obx(() {
                        if (controller.filteredNotes.isEmpty) {
                          return const Center(child: Text('No Notes Found'));
                        }
                        return controller.isGrid.value
                            ? GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                                padding: const EdgeInsets.all(10),
                                itemCount: controller.filteredNotes.length,
                                itemBuilder: (context, index) {
                                  return NoteTile(index: index);
                                },
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(10),
                                itemCount: controller.filteredNotes.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      NoteTile(index: index),
                                      const SizedBox(height: 16),
                                    ],
                                  );
                                },
                              );
                      }),
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.white.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      12.0), // Adjust the radius as needed
                  side: const BorderSide(
                    color: Colors.white, // Border color
                    width: 1.0, // Border width
                  ),
                ),
                elevation: 0,
                onPressed: () => Get.to(() => NoteEditor()),
                child: const Icon(Icons.add),
              ),
            ),
          );
        }));
  }
}
