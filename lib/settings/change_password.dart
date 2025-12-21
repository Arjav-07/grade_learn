import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// --- Brutalist Design Constants ---
const Color kBrutalistBg = Color(0xFFFFFFF9);
const Color kBrutalistYellow = Color(0xFFFDE798);
const Color kBrutalistBlue = Color(0xFFB5D8FF);
const Color kBrutalistPurple = Color(0xFF7A64D8);
const Color kDarkTextColor = Color(0xFF282C35);
const Color kErrorColor = Colors.red;

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    final currentPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      _showErrorSnackbar('ALL FIELDS ARE REQUIRED.');
      return;
    }

    if (newPassword != confirmPassword) {
      _showErrorSnackbar('NEW PASSWORDS DO NOT MATCH.');
      return;
    }

    setState(() { _isLoading = true; });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) {
        _showErrorSnackbar('NO USER LOGGED IN.');
        setState(() { _isLoading = false; });
        return;
      }

      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PASSWORD CHANGED SUCCESSFULLY!', style: TextStyle(fontWeight: FontWeight.w900)),
            backgroundColor: Colors.black,
          ),
        );
        Navigator.of(context).pop();
      }

    } on FirebaseAuthException catch (e) {
      String errorMessage = 'AN ERROR OCCURRED.';
      if (e.code == 'wrong-password') {
        errorMessage = 'CURRENT PASSWORD INCORRECT.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'NEW PASSWORD IS TOO WEAK.';
      }
      _showErrorSnackbar(errorMessage);
    } catch (e) {
      _showErrorSnackbar('UNEXPECTED ERROR: $e');
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  void _showErrorSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, style: const TextStyle(fontWeight: FontWeight.w900)),
          backgroundColor: kErrorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBrutalistBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // --- BACK BUTTON ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back, size: 28, color: Colors.black),
                    SizedBox(width: 8),
                    Text(
                      "BACK",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1.1),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'SECURITY 🔐',
                style: TextStyle(fontSize: 38, fontWeight: FontWeight.w900, height: 1.1),
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                children: [
                  const Text(
                    'YOUR NEW PASSWORD MUST BE DIFFERENT FROM PREVIOUSLY USED PASSWORDS.',
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.black54, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),

                  // --- Input Fields ---
                  _buildBrutalistPasswordField(
                    controller: _currentPasswordController,
                    labelText: 'CURRENT PASSWORD',
                    icon: Icons.lock_open,
                    isVisible: _isCurrentPasswordVisible,
                    onToggleVisibility: () {
                      setState(() => _isCurrentPasswordVisible = !_isCurrentPasswordVisible);
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildBrutalistPasswordField(
                    controller: _newPasswordController,
                    labelText: 'NEW PASSWORD',
                    icon: Icons.lock_outline,
                    isVisible: _isNewPasswordVisible,
                    onToggleVisibility: () {
                      setState(() => _isNewPasswordVisible = !_isNewPasswordVisible);
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildBrutalistPasswordField(
                    controller: _confirmPasswordController,
                    labelText: 'CONFIRM NEW PASSWORD',
                    icon: Icons.verified_user_outlined,
                    isVisible: _isConfirmPasswordVisible,
                    onToggleVisibility: () {
                      setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
                    },
                  ),
                  const SizedBox(height: 40),

                  // --- Submit Button ---
                  _buildSubmitButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrutalistPasswordField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(labelText, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.black, width: 2.5),
            boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
          ),
          child: TextField(
            controller: controller,
            obscureText: !isVisible,
            style: const TextStyle(fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.black),
              suffixIcon: IconButton(
                icon: Icon(isVisible ? Icons.visibility_off : Icons.visibility, color: Colors.black),
                onPressed: onToggleVisibility,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _changePassword,
      child: Container(
        height: 65,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: kBrutalistPurple, offset: Offset(4, 4))],
        ),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  'CHANGE PASSWORD',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
        ),
      ),
    );
  }
}