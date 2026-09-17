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
  static const Color _primaryColor = Color(0xFFE50046);
  static const Color _backgroundColor = Color(0xFFF8F8F8);
  static const Color _dividerColor = Color(0xFFF2F2F2);
  static const Color _mutedTextColor = Color(0xFF9E9E9E);

  final ImagePicker _picker = ImagePicker();

  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController emailController;
  late final TextEditingController addressController;

  String? imagePath;
  bool isAvailable = true;

  String get fullName {
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final name = '$firstName $lastName'.trim();
    return name.isEmpty ? 'Your name' : name;
  }

  String get email {
    final savedEmail = emailController.text.trim();
    return savedEmail.isEmpty ? 'No email added' : savedEmail;
  }

  String get address {
    final savedAddress = addressController.text.trim();
    return savedAddress.isEmpty ? 'Add your address' : savedAddress;
  }

  @override
  void initState() {
    super.initState();
    imagePath = AppPreferences.profileImagePath;
    firstNameController = TextEditingController(text: AppPreferences.firstName);
    lastNameController = TextEditingController(text: AppPreferences.lastName);
    emailController = TextEditingController(text: AppPreferences.email);
    addressController = TextEditingController(text: AppPreferences.address);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    await AppPreferences.setProfileImagePath(image.path);

    if (!mounted) return;
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
    setState(() {});
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Profile updated')));
  }

  Future<void> _openEditProfileSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Edit Profile',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 20),
              _buildTextField('First Name', firstNameController),
              const SizedBox(height: 14),
              _buildTextField('Last Name', lastNameController),
              const SizedBox(height: 14),
              _buildTextField(
                'Email',
                emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 14),
              _buildTextField('Address', addressController),
              const SizedBox(height: 22),
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: () async {
                    await saveChanges();
                    if (context.mounted) Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: _backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ProfileTopBar(onBack: () => Navigator.maybePop(context)),
                    const SizedBox(height: 28),
                    const Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: _ProfileAvatar(
                        imagePath: imagePath,
                        onEdit: pickImage,
                      ),
                    ),
                    const SizedBox(height: 38),
                    _SectionTitle('Personal Info'),
                    const SizedBox(height: 14),
                    _InfoCard(
                      children: [
                        _InfoRow(label: 'Your name', value: fullName),
                        const _CardDivider(),
                        const _InfoRow(label: 'Occupation', value: 'Manager'),
                        const _CardDivider(),
                        const _InfoRow(
                          label: 'Employer',
                          value: 'Food Couriers',
                        ),
                        const _CardDivider(),
                        _SwitchInfoRow(
                          title: 'Nigeria',
                          value: isAvailable,
                          onChanged: (value) {
                            setState(() => isAvailable = value);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _SectionTitle('Contact Info'),
                    const SizedBox(height: 14),
                    _InfoCard(
                      children: [
                        const _InfoRow(
                          label: 'Phone number',
                          value: '+234 813 0400 445',
                        ),
                        const _CardDivider(),
                        _InfoRow(label: 'Email', value: email),
                        const _CardDivider(),
                        _InfoRow(label: 'Address', value: address),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: _openEditProfileSheet,
                        icon: const Icon(Icons.edit_rounded),
                        label: const Text('Edit Profile'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ),
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

class _ProfileTopBar extends StatelessWidget {
  const _ProfileTopBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _SoftIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          tooltip: 'Back',
          onPressed: onBack,
        ),
        _SoftIconButton(
          icon: Icons.notifications_none_rounded,
          tooltip: 'Notifications',
          onPressed: () {},
        ),
      ],
    );
  }
}

class _SoftIconButton extends StatelessWidget {
  const _SoftIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: IconButton(
        onPressed: onPressed,
        tooltip: tooltip,
        style: IconButton.styleFrom(
          backgroundColor: const Color(0xFFFFF0F4),
          foregroundColor: _ProfileViewState._primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: Icon(icon, size: 26),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.imagePath, required this.onEdit});

  final String? imagePath;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final hasImage = imagePath != null && File(imagePath!).existsSync();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 122,
          height: 122,
          decoration: const BoxDecoration(
            color: Color(0xFFFFE6EC),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(9),
          child: CircleAvatar(
            backgroundColor: const Color(0xFFFFF7F9),
            backgroundImage: hasImage ? FileImage(File(imagePath!)) : null,
            child: hasImage
                ? null
                : const Icon(
                    Icons.person_rounded,
                    size: 62,
                    color: _ProfileViewState._primaryColor,
                  ),
          ),
        ),
        Positioned(
          right: -2,
          bottom: 10,
          child: SizedBox(
            width: 44,
            height: 44,
            child: IconButton(
              onPressed: onEdit,
              tooltip: 'Change photo',
              style: IconButton.styleFrom(
                backgroundColor: _ProfileViewState._primaryColor,
                foregroundColor: Colors.white,
                shape: const CircleBorder(),
              ),
              icon: const Icon(Icons.edit_rounded, size: 22),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: _ProfileViewState._mutedTextColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: const TextStyle(
                color: Color(0xFF242424),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SwitchInfoRow extends StatelessWidget {
  const _SwitchInfoRow({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF242424),
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: _ProfileViewState._primaryColor,
            activeTrackColor: const Color(0xFFF58BAC),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFE8E8E8),
          ),
        ],
      ),
    );
  }
}

class _CardDivider extends StatelessWidget {
  const _CardDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      color: _ProfileViewState._dividerColor,
    );
  }
}
