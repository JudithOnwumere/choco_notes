import 'dart:ui';

import 'package:choconotes/controllers/note_controller.dart';
import 'package:flutter/material.dart';
import 'package:choconotes/styles/app_strings.dart';
import 'package:get/get.dart';

class AppSearchBar extends StatelessWidget {
  const AppSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final NoteController controller = Get.find();

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ClipRRect(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background blur effect
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4), // Blur effect
                child: Container(
                  color: Colors.black
                      .withOpacity(0), // Transparent container to apply blur
                ),
              ),
            ),
            // The TextField
            TextField(
              onChanged: controller.searchNotes,
              decoration: InputDecoration(
                hintText: AppStrings.appSearchBar,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12), // Set custom border radius
                  borderSide: BorderSide(
                    color: Colors.white.withOpacity(0.25), // Border color
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.white, // Use the same color for enabled state
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.white,
                    width: 1.5,
                  ),
                ),
                filled: true,
                fillColor: Colors.white
                    .withOpacity(0.25), // Background color of the text field
              ),
            ),
          ],
        ),
      ),
    );
  }
}
