import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:otlopapp/core/storage/app_preferences.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ImagePicker _picker = ImagePicker();

  String? imagePath;

  late TextEditingController firstNameController;

  late TextEditingController lastNameController;

  late TextEditingController emailController;

  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();

    imagePath = AppPreferences.profileImagePath;

    firstNameController = TextEditingController(text: AppPreferences.firstName);

    lastNameController = TextEditingController(text: AppPreferences.lastName);

    emailController = TextEditingController(text: AppPreferences.email);

    addressController = TextEditingController(text: AppPreferences.address);
  }

  Future<void> pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    await AppPreferences.setProfileImagePath(image.path);

    setState(() {
      imagePath = image.path;
    });
  }

  Future<void> saveChanges() async {
    await AppPreferences.saveUserData(
      firstName: firstNameController.text.trim(),

      lastName: lastNameController.text.trim(),

      email: emailController.text.trim(),
    );

    await AppPreferences.setAddress(addressController.text.trim());

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Profile updated')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile'), centerTitle: true),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,

              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,

                    backgroundImage: imagePath != null
                        ? FileImage(File(imagePath!))
                        : null,

                    child: imagePath == null
                        ? const Icon(Icons.person, size: 60)
                        : null,
                  ),

                  Positioned(
                    bottom: 0,
                    right: 0,

                    child: CircleAvatar(
                      backgroundColor: const Color(0xFFE50046),

                      child: IconButton(
                        onPressed: pickImage,

                        icon: const Icon(Icons.camera_alt, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: firstNameController,

              decoration: const InputDecoration(
                labelText: 'First Name',

                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: lastNameController,

              decoration: const InputDecoration(
                labelText: 'Last Name',

                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: emailController,

              decoration: const InputDecoration(
                labelText: 'Email',

                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: addressController,

              decoration: const InputDecoration(
                labelText: 'Address',

                hintText: 'Add your address',

                prefixIcon: Icon(Icons.location_on_outlined),

                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(
                onPressed: saveChanges,

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE50046),

                  foregroundColor: Colors.white,
                ),

                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
