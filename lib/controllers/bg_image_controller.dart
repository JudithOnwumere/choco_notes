import 'dart:ui';

import 'package:choco_notes/styles/app_colours.dart';
import 'package:choco_notes/styles/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:choco_notes/styles/app_strings.dart';
import 'package:permission_handler/permission_handler.dart';

class BackgroundImageController extends GetxController {
  final storage = GetStorage(); // GetStorage instance for persistence
  var backgroundImagePath = 'assets/images/bgdefault.jpeg'
      .obs; // Observable variable for the image path

  @override
  void onInit() {
    super.onInit();
    loadBackgroundImage(); // Load the saved background image on initialization
  }

  // Pick an image from the gallery
  Future<void> pickImageFromGallery() async {
    try {
      // Request or check permission
      final permissionStatus = await Permission.photos.request();

      if (permissionStatus.isGranted) {
        // Permission granted, pick the image
        final ImagePicker picker = ImagePicker();
        final XFile? pickedFile =
            await picker.pickImage(source: ImageSource.gallery);

        if (pickedFile != null && pickedFile.path.isNotEmpty) {
          // Assuming backgroundImagePath is an RxString
          backgroundImagePath.value = pickedFile.path;
          saveBackgroundImage(
            pickedFile.path,
          ); // Save the picked image to storage
        }
      } else if (permissionStatus.isDenied) {
        // Permission denied, notify the user
        Get.snackbar('Permission Denied',
            'Gallery access is required to pick an image.');
      } else if (permissionStatus.isPermanentlyDenied) {
        // Permission permanently denied, suggest opening app settings
        Get.snackbar(
          'Permission Required',
          'Please enable gallery access in app settings to pick an image.',
          mainButton: TextButton(
            onPressed: () {
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        );
      }
    } catch (e) {
      // Handle any errors gracefully
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  // Function to reset the image to the default
  void resetToDefaultImage() {
    backgroundImagePath.value = 'assets/images/bgdefault.jpeg';
    saveBackgroundImage('assets/images/bgdefault.jpeg');
  }

  // Save the background image path to GetStorage
  void saveBackgroundImage(String path) {
    storage.write('backgroundImagePath', path);
  }

  // Load the background image path from GetStorage
  void loadBackgroundImage() {
    String? savedPath = storage.read<String>('backgroundImagePath');
    if (savedPath != null && savedPath.isNotEmpty) {
      backgroundImagePath.value = savedPath;
    }
  }

  // Function to show a dialog
  void showImageOptionsDialog(BuildContext context) {
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
            title: const Text(AppStrings.imgPickerAlertTitle),
            content: const Text(
              AppStrings.imgPickerAlertContent,
              style: AppTextStyles.imgPickerAlertContent,
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        resetToDefaultImage();
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8.0), // Adjust the radius as needed
                        ),
                      ),
                      child: const Text(
                        AppStrings.imgPickerAlertResetBtn,
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
                        pickImageFromGallery();
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: AppColours.linearGrad1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8.0), // Adjust the radius as needed
                        ),
                      ),
                      child: const Text(
                        AppStrings.imgPickerAlertPickBtn,
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
