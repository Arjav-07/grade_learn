import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Required for FieldValue
import 'package:grade_learn/services/user_service.dart'; // 🌟 Import the new service file

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // 🌟 Controllers for form fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 🌟 Initialize the Service for Firestore operations
  final UserService _userService = UserService();

  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _isLoading = false; // 🌟 Loading state for the button

  // --- COLOR PALETTE ---
  final Color _primaryColor = Colors.black87;
  final Color _textColor = const Color(0xFF64748B);

  // 🌟 1. Sign Up Method (UPDATED)
  Future<void> _signUp() async {
    // Basic local validation
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty || _usernameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final username = _usernameController.text.trim();

    try {
      // 1. Create user in Firebase Authentication
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (user != null) {
        // 2. Save the profile data to Firestore using the new user's UID
        // We wrap this crucial step in its own try/catch for specific debugging.
        try {
          await _userService.createUserProfile(
            uid: user.uid,
            username: username,
            email: email,
          );

          // On success, show message and pop back to login screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration Successful! Profile Stored.')),
          );
          Navigator.pop(context);
        } catch (dbError) {
          // If Firestore fails, but Auth succeeded, log the user out
          // and inform the user that their profile creation failed.
          await user.delete();
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile creation failed. Check Firebase Rules and console logs.')),
          );
          print('!!! Firestore Write Error: $dbError');
        }
      }
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak (min 6 characters).';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is not valid.';
      } else {
        message = e.message ?? 'An unknown registration error occurred.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      print('!!! General Sign Up Error: $e'); // Log general errors
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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

                // 1. Illustration
                const _IllustrationArea(),

                const SizedBox(height: 20),

                // 2. Title
                Text(
                  "Register",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: _primaryColor,
                  ),
                ),

                const SizedBox(height: 8),

                // 3. Subtitle
                Text(
                  "Please register to login.",
                  style: TextStyle(
                    fontSize: 16,
                    color: _textColor,
                  ),
                ),

                const SizedBox(height: 24),

                // 4. Form Fields
                _CustomTextField(
                  controller: _usernameController, // 🌟 Linked
                  icon: Icons.person_outline,
                  hintText: 'Username',
                  primaryColor: _primaryColor,
                  keyboardType: TextInputType.text,
                ),

                const SizedBox(height: 16),

                _CustomTextField(
                  controller: _emailController, // 🌟 Linked for Firebase Auth
                  icon: Icons.email_outlined, // Changed icon for email
                  hintText: 'Email Address', // Changed hint for Firebase Auth
                  primaryColor: _primaryColor,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 16),

                _PasswordField(
                  controller: _passwordController, // 🌟 Linked
                  obscurePassword: _obscurePassword,
                  primaryColor: _primaryColor,
                  onToggle: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),

                const SizedBox(height: 20),

                // 5. Remember Me Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Reminder me next time",
                      style: TextStyle(
                        color: _textColor,
                        fontSize: 14,
                      ),
                    ),
                    Switch(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value;
                        });
                      },
                      activeColor: _primaryColor,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 6. Sign Up Button
                _ActionButton(
                  label: 'Sign Up',
                  primaryColor: _primaryColor,
                  onPressed: _isLoading ? () {} : _signUp, // 🌟 Call _signUp
                  isLoading: _isLoading, // 🌟 Pass loading state
                ),

                const SizedBox(height: 24),

                // 7. OR Divider (FIXED: Replaced Expanded with flexible wrapping)
                Row(
                  children: [
                    const Flexible(child: Divider(color: Colors.grey, height: 1)), // Use Flexible instead of Expanded
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "OR",
                        style: TextStyle(
                          color: _textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Flexible(child: Divider(color: Colors.grey, height: 1)), // Use Flexible instead of Expanded
                  ],
                ),

                const SizedBox(height: 24),

                // 8. Social Login Buttons
                const _SocialLoginButtons(),

                const SizedBox(height: 20),

                // 9. Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have account? ",
                      style: TextStyle(
                        color: _textColor,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
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

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
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
      height: 180
      ,
      child: Center(
        child: Image.asset(
          'assets/images/register.png',
          height: 180,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/images/signup.png',
              height: 180,
              errorBuilder: (_, __, ___) {
                return Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person_add,
                      size: 80,
                      color: Colors.black87,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// --- SOCIAL LOGIN BUTTONS (No change) ---

class _SocialLoginButtons extends StatelessWidget {
  const _SocialLoginButtons();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SocialButton(
          icon: Image.asset(
            'assets/images/google.png',
            height: 28,
            width: 28,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.g_mobiledata, color: Color(0xFFDB4437), size: 28);
            },
          ),
          onPressed: () {
            // TODO: Implement Google Sign-In for sign up
            print('Google sign up pressed');
          },
        ),
        const SizedBox(width: 20),
        _SocialButton(
          icon: Image.asset(
            'assets/images/github.png',
            height: 28,
            width: 28,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.code, color: Colors.black87, size: 28);
            },
          ),
          onPressed: () {
            // TODO: Implement GitHub Sign-In for sign up
            print('GitHub sign up pressed');
          },
        ),

      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        padding: EdgeInsets.zero,
      ),
    );
  }
}

// --- CUSTOM TEXT FIELD (Updated to take controller and keyboard type) ---

class _CustomTextField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final Color primaryColor;
  final TextEditingController? controller;
  final TextInputType keyboardType;

  const _CustomTextField({
    required this.icon,
    required this.hintText,
    required this.primaryColor,
    this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller, // 🌟 Use controller
        keyboardType: keyboardType, // 🌟 Use keyboard type
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
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
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

// --- PASSWORD FIELD WITH TOGGLE (Updated to take controller) ---

class _PasswordField extends StatelessWidget {
  final bool obscurePassword;
  final Color primaryColor;
  final VoidCallback onToggle;
  final TextEditingController? controller;

  const _PasswordField({
    required this.obscurePassword,
    required this.primaryColor,
    required this.onToggle,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller, // 🌟 Use controller
        obscureText: obscurePassword,
        decoration: InputDecoration(
          hintText: '************',
          hintStyle: const TextStyle(
            color: Color(0xFFB0B8C1),
            fontSize: 15,
            letterSpacing: 2,
          ),
          prefixIcon: const Icon(
            Icons.lock_outline,
            color: Color(0xFF64748B),
            size: 22,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: const Color(0xFF64748B),
              size: 22,
            ),
            onPressed: onToggle,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
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
  final bool isLoading;

  const _ActionButton({
    required this.label,
    required this.primaryColor,
    required this.onPressed,
    this.isLoading = false,
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
            borderRadius: BorderRadius.circular(30),
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
