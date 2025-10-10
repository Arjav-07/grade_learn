import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grade_learn/auth/forgotpassword_page.dart';
import 'package:grade_learn/auth/signup_page.dart';
import 'package:grade_learn/widgets/main_navigation_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 1. Controllers for text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _isLoading = false; // Loading state for the button

  // --- COLOR PALETTE ---
  final Color _primaryColor = Colors.black87;
  final Color _textColor = const Color(0xFF64748B);

  // 2. Sign In Method
  Future<void> _signIn() async {
    // Basic validation to prevent empty sign-in attempt
    if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password.')),
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Attempt to sign in with email and password
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Successfully signed in.
      // Use pushReplacement to prevent user from navigating back to login
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successful!')),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainNavigationScreen())
        );
      }

    } on FirebaseAuthException catch (e) {
      String message;
      // Handle common Firebase Auth errors
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        message = 'Invalid login credentials.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is not valid.';
      } else {
        message = e.message ?? 'An unknown authentication error occurred.';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } catch (e) {
       if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
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
                  "Login",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: _primaryColor,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // 3. Subtitle
                Text(
                  "Please Sign in to continue.",
                  style: TextStyle(
                    fontSize: 16,
                    color: _textColor,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // 4. Email Field
                _CustomTextField(
                  controller: _emailController,
                  icon: Icons.person_outline,
                  hintText: 'Email Address',
                  primaryColor: _primaryColor,
                  keyboardType: TextInputType.emailAddress,
                ),
                
                const SizedBox(height: 16),
                
                // 5. Password Field
                _PasswordField(
                  controller: _passwordController,
                  obscurePassword: _obscurePassword,
                  primaryColor: _primaryColor,
                  onToggle: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                
                const SizedBox(height: 20),
                
                // 6. Remember Me Toggle & Forgot Password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
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
                    GestureDetector(
                      onTap: () {
                         Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()));
                      },
                      child: Text(
                        "Forgot?",
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
                
                // 7. Sign In Button
                _ActionButton(
                  label: 'Sign In',
                  primaryColor: _primaryColor,
                  onPressed: _isLoading ? () {} : _signIn,
                  isLoading: _isLoading,
                ),
                
                const SizedBox(height: 24),
                
                // 8. OR Divider
                Row(
                  children: [
                    const Expanded(child: Divider(color: Colors.grey, height: 1)),
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
                    const Expanded(child: Divider(color: Colors.grey, height: 1)),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // 9. Social Login Buttons
                const _SocialLoginButtons(),
                
                const SizedBox(height: 20),
                
                // 10. Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have account? ",
                      style: TextStyle(
                        color: _textColor,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                         Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
                      },
                      child: Text(
                        "Sign Up",
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
    // This widget relies on local assets, which won't load in a preview.
    // I'm using a simple placeholder icon for safety.
    return SizedBox(
      height: 180,
      child: Center(
        child: Container(
          height: 180,
          child: Center(
            child: Image.asset('assets/images/signin.png'),
          ),
        )
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
          // Placeholder for Google Icon
          icon: Image.asset('assets/images/google.png',
          height: 34,
          width: 34,),
          
          onPressed: () {
            // TODO: Implement Google Sign-In with Firebase
            debugPrint('Google login pressed');
          },
        ),
        const SizedBox(width: 20),
        _SocialButton(
          // Placeholder for GitHub Icon
          icon: Image.asset('assets/images/github.png',
          height: 34,
          width: 34,),
          onPressed: () {
            // TODO: Implement GitHub Sign-In with Firebase
            debugPrint('GitHub login pressed');
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

// --- CUSTOM TEXT FIELD ---

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
        controller: controller,
        keyboardType: keyboardType,
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

// --- PASSWORD FIELD WITH TOGGLE ---

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
        controller: controller,
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

// --- ACTION BUTTON ---

class _ActionButton extends StatelessWidget {
  final String label;
  final Color primaryColor;
  final VoidCallback? onPressed;
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
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: isLoading
            ? const SizedBox(
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
