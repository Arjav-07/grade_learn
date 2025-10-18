// change_password.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// --- UI Constants for consistent theming ---
const Color kBackgroundColor = Color(0xFFF7F7F9);
const Color kPrimaryColor = Color(0xFF7A64D8);
const Color kDarkTextColor = Color(0xFF282C35);
const Color kSecondaryTextColor = Colors.grey;
const Color kErrorColor = Colors.red;

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  // Controllers to manage the text in the input fields
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // For toggling password visibility
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  
  // To show a loading indicator during the process
  bool _isLoading = false;

  @override
  void dispose() {
    // Clean up the controllers when the widget is removed from the widget tree
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Handles the entire password change process
  Future<void> _changePassword() async {
    // 1. --- FORM VALIDATION ---
    final currentPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      _showErrorSnackbar('All fields are required.');
      return;
    }

    if (newPassword != confirmPassword) {
      _showErrorSnackbar('New passwords do not match.');
      return;
    }

    setState(() { _isLoading = true; });

    // 2. --- FIREBASE RE-AUTHENTICATION AND PASSWORD UPDATE ---
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) {
        _showErrorSnackbar('No user is logged in or user email is not available.');
        setState(() { _isLoading = false; });
        return;
      }

      // Re-authenticate the user with their current password.
      // This is a security measure required by Firebase.
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(cred);

      // If re-authentication is successful, update the password
      await user.updatePassword(newPassword);

      // 3. --- SUCCESS FEEDBACK ---
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password changed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        // Go back to the previous page (e.g., Settings)
        Navigator.of(context).pop();
      }

    } on FirebaseAuthException catch (e) {
      // 4. --- ERROR HANDLING ---
      String errorMessage = 'An error occurred. Please try again.';
      if (e.code == 'wrong-password') {
        errorMessage = 'The current password you entered is incorrect.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'The new password is too weak.';
      } else {
        errorMessage = e.message ?? errorMessage;
      }
      _showErrorSnackbar(errorMessage);
    } catch (e) {
      _showErrorSnackbar('An unexpected error occurred: $e');
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  /// Helper to show a styled error message
  void _showErrorSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: kErrorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kDarkTextColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Change Password',
          style: TextStyle(color: kDarkTextColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        children: [
          const Text(
            'Your new password must be different from previously used passwords.',
            textAlign: TextAlign.center,
            style: TextStyle(color: kSecondaryTextColor, fontSize: 15),
          ),
          const SizedBox(height: 30),

          // --- Input Fields ---
          _buildPasswordTextField(
            controller: _currentPasswordController,
            labelText: 'Current Password',
            isVisible: _isCurrentPasswordVisible,
            onToggleVisibility: () {
              setState(() => _isCurrentPasswordVisible = !_isCurrentPasswordVisible);
            },
          ),
          const SizedBox(height: 20),
          _buildPasswordTextField(
            controller: _newPasswordController,
            labelText: 'New Password',
            isVisible: _isNewPasswordVisible,
            onToggleVisibility: () {
              setState(() => _isNewPasswordVisible = !_isNewPasswordVisible);
            },
          ),
          const SizedBox(height: 20),
          _buildPasswordTextField(
            controller: _confirmPasswordController,
            labelText: 'Confirm New Password',
            isVisible: _isConfirmPasswordVisible,
            onToggleVisibility: () {
              setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
            },
          ),
          const SizedBox(height: 40),

          // --- Submit Button ---
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _changePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Change Password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  /// A helper method to build a styled password text field to avoid code repetition.
  Widget _buildPasswordTextField({
    required TextEditingController controller,
    required String labelText,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
  }) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: kSecondaryTextColor),
        prefixIcon: const Icon(Icons.lock_outline, color: kSecondaryTextColor),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility_off : Icons.visibility,
            color: kSecondaryTextColor,
          ),
          onPressed: onToggleVisibility,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}