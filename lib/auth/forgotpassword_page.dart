import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 🌟 Import Firebase Auth
// Assuming this is your LoginScreen path

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // 🌟 Controllers and State
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  // --- COLOR PALETTE ---
  final Color _primaryColor = Colors.black87;
  final Color _textColor = const Color(0xFF64748B);

  // 🌟 Password Reset Method
  Future<void> _resetPassword() async {
    setState(() {
      _isLoading = true;
    });

    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email address.')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );

      // On success, show the custom success dialog
      _showSuccessDialog();

    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'No user found for this email address.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is not valid.';
      } else {
        message = e.message ?? 'Failed to send reset link. Please try again.';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                
                // Back Button
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: _primaryColor,
                    ),
                    onPressed: () { 
                      Navigator.pop(context); // Go back to LoginScreen
                    },
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // 1. Illustration
                const _IllustrationArea(),
                
                const SizedBox(height: 40),
                
                // 2. Title
                Text(
                  "Forgot Password?",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: _primaryColor,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // 3. Subtitle
                Text(
                  "Don't worry! It happens. Please enter the email address associated with your account.",
                  style: TextStyle(
                    fontSize: 15,
                    color: _textColor,
                    height: 1.5,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // 4. Email Field (Updated)
                _CustomTextField(
                  controller: _emailController, // 🌟 Linked controller
                  icon: Icons.email_outlined,
                  hintText: 'Email Address',
                  primaryColor: _primaryColor,
                ),
                
                const SizedBox(height: 32),
                
                // 5. Submit Button (Updated)
                _ActionButton(
                  label: 'Reset Password',
                  primaryColor: _primaryColor,
                  onPressed: _isLoading ? () {} : _resetPassword, // 🌟 Call reset method
                  isLoading: _isLoading, // 🌟 Pass loading state
                ),
                
                const SizedBox(height: 20),
                
                // 6. Back to Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Remember your password? ",
                      style: TextStyle(
                        color: _textColor,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Go back to LoginScreen
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          color: _primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Icon(
          Icons.check_circle_outline,
          color: Color(0xFF2C3E50),
          size: 64,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Check Your Email",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "We have sent password recovery instructions to your email.",
              style: TextStyle(
                fontSize: 14,
                color: _textColor,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              // Pop dialog, then pop back to login screen
              onPressed: () {
                Navigator.pop(context); 
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                "OK",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- ILLUSTRATION AREA (No change) ---

class _IllustrationArea extends StatelessWidget {
  const _IllustrationArea();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Image.asset(
          'assets/images/forgot_password.png',
          height: 180,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset('assets/images/forgotpassword.png',
                errorBuilder: (_, __, ___) {
                  return const Center(child: Icon(Icons.lock_open, size: 80, color: Colors.black87));
                },
              )
            );
          },
        ),
      ),
    );
  }
}

// --- CUSTOM TEXT FIELD (Updated to take controller) ---

class _CustomTextField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final Color primaryColor;
  final TextEditingController? controller; // 🌟 Added controller

  const _CustomTextField({
    required this.icon,
    required this.hintText,
    required this.primaryColor,
    this.controller, // 🌟 Added controller
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller, // 🌟 Use controller
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFFB0B8C1),
            fontSize: 15,
          ),
          prefixIcon: Icon(
            icon,
            color: const Color(0xFF64748B),
            size: 22,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryColor, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
        ),
      ),
    );
  }
}

// --- ACTION BUTTON (Updated to show loading state) ---

class _ActionButton extends StatelessWidget {
  final String label;
  final Color primaryColor;
  final VoidCallback onPressed;
  final bool isLoading; // 🌟 Added loading state

  const _ActionButton({
    required this.label,
    required this.primaryColor,
    required this.onPressed,
    this.isLoading = false, // 🌟 Default to false
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed, // Disable button when loading
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: isLoading
            ? const SizedBox( // 🌟 Show spinner when loading
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }
}
