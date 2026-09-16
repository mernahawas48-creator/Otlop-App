import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:otlopapp/core/networking/api_error_handler.dart';
import 'package:otlopapp/core/storage/app_preferences.dart';
import 'package:otlopapp/core/utils/display_awesome_dialog.dart';

import 'package:otlopapp/features/auth/otp_screen.dart';
import 'package:otlopapp/features/auth/repos/auth_repo.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();

  final TextEditingController _lastNameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final AuthRepo _authRepo = AuthRepo();

  final ImagePicker _imagePicker = ImagePicker();

  bool _isLoading = false;

  bool _obscurePassword = true;

  String? _profileImagePath;

  // =========================
  // PICK PROFILE IMAGE
  // =========================

  Future<void> _pickProfileImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) {
      return;
    }

    setState(() {
      _profileImagePath = image.path;
    });
  }

  // =========================
  // CREATE ACCOUNT
  // =========================

  Future<void> _createAccount() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authRepo.signUp(
        email: _emailController.text.trim(),

        password: _passwordController.text,

        firstName: _firstNameController.text.trim(),

        lastName: _lastNameController.text.trim(),
      );

      // Save account data locally
      // for the Profile page.

      await AppPreferences.saveUserData(
        firstName: _firstNameController.text.trim(),

        lastName: _lastNameController.text.trim(),

        email: _emailController.text.trim(),
      );

      // Save selected profile image.

      if (_profileImagePath != null) {
        await AppPreferences.setProfileImagePath(_profileImagePath!);
      }

      if (!mounted) {
        return;
      }

      // IMPORTANT:
      // No success dialog here.
      // Go directly to OTP.

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpScreen(email: _emailController.text.trim()),
        ),
      );
    } on DioException catch (e) {
      if (!mounted) {
        return;
      }

      displayAwesomeDialog(
        context,

        errorMessage: ApiErrorHandeler.handleError(e),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      displayAwesomeDialog(
        context,

        errorMessage:
            'Unable to create the account. '
            'Please try again.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // =========================
  // PASSWORD VALIDATOR
  // =========================

  String? _validatePassword(String? value) {
    final String password = value ?? '';

    if (password.isEmpty) {
      return 'Please enter your password';
    }

    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }

    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Password must contain an uppercase letter';
    }

    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'Password must contain a lowercase letter';
    }

    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Password must contain a number';
    }

    if (!RegExp(r'[^A-Za-z0-9]').hasMatch(password)) {
      return 'Password must contain a special character';
    }

    return null;
  }

  // =========================
  // DISPOSE
  // =========================

  @override
  void dispose() {
    _firstNameController.dispose();

    _lastNameController.dispose();

    _emailController.dispose();

    _passwordController.dispose();

    super.dispose();
  }

  // =========================
  // UI
  // =========================

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),

      child: Form(
        key: _formKey,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // =========================
            // PROFILE IMAGE
            // =========================

            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickProfileImage,

                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,

                          backgroundColor: Colors.grey.shade200,

                          backgroundImage: _profileImagePath != null
                              ? FileImage(File(_profileImagePath!))
                              : null,

                          child: _profileImagePath == null
                              ? const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.grey,
                                )
                              : null,
                        ),

                        Positioned(
                          right: 0,
                          bottom: 0,

                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFFE50046),

                              shape: BoxShape.circle,
                            ),

                            child: const Padding(
                              padding: EdgeInsets.all(8),

                              child: Icon(
                                Icons.camera_alt,

                                color: Colors.white,

                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Add profile picture',

                    style: TextStyle(
                      color: Color(0xFFE50046),

                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // =========================
            // FIRST NAME
            // =========================
            const Text(
              'First Name',

              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 6),

            TextFormField(
              controller: _firstNameController,

              decoration: const InputDecoration(
                hintText: 'First Name',

                border: OutlineInputBorder(),
              ),

              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your first name';
                }

                return null;
              },
            ),

            const SizedBox(height: 15),

            // =========================
            // LAST NAME
            // =========================
            const Text(
              'Last Name',

              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 6),

            TextFormField(
              controller: _lastNameController,

              decoration: const InputDecoration(
                hintText: 'Last Name',

                border: OutlineInputBorder(),
              ),

              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your last name';
                }

                return null;
              },
            ),

            const SizedBox(height: 15),

            // =========================
            // EMAIL
            // =========================
            const Text('Email', style: TextStyle(fontWeight: FontWeight.w600)),

            const SizedBox(height: 6),

            TextFormField(
              controller: _emailController,

              keyboardType: TextInputType.emailAddress,

              decoration: const InputDecoration(
                hintText: 'Email Address',

                border: OutlineInputBorder(),
              ),

              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your email';
                }

                final bool validEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                    .hasMatch(value.trim());

                if (!validEmail) {
                  return 'Please enter a valid email';
                }

                return null;
              },
            ),

            const SizedBox(height: 15),

            // =========================
            // PASSWORD
            // =========================
            const Text(
              'Password',

              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 6),

            TextFormField(
              controller: _passwordController,

              obscureText: _obscurePassword,

              decoration: InputDecoration(
                hintText: 'Password',

                border: const OutlineInputBorder(),

                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },

                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),

              validator: _validatePassword,
            ),

            const SizedBox(height: 5),

            Text(
              'Use uppercase, lowercase, number and special character.',

              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),

            const SizedBox(height: 25),

            // =========================
            // SIGN UP BUTTON
            // =========================
            SizedBox(
              width: double.infinity,

              height: 50,

              child: ElevatedButton(
                onPressed: _isLoading ? null : _createAccount,

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE50046),

                  foregroundColor: Colors.white,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,

                        child: CircularProgressIndicator(
                          strokeWidth: 2,

                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Sign Up',

                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
            ),

            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
