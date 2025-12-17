import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grade_learn/auth/forgotpassword_page.dart';
import 'package:grade_learn/auth/signup_page.dart';
import 'package:grade_learn/widgets/main_navigation_screen.dart';

// --- Global Constants for Styling ---
const Color _primaryColor = Colors.black87;
final Color _textColor = Colors.black.withOpacity(0.5);
const Color _fieldBackgroundColor = Color(0xFFF8F9FA);
const Color _screenBackgroundColor = Color(0xFFFFFFF9); 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 1. Controllers and State
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false; // Manages the loading state of the Sign In button
  
  // 2. Firebase Sign In Logic
  Future<void> _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('PLEASE ENTER BOTH EMAIL AND PASSWORD.');
      return;
    }
    
    _setLoading(true);
    
    try {
      // 🔑 Core Firebase Sign-in Call
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Navigate to main screen on success
      if (mounted) {
        _showSnackBar('LOGIN SUCCESSFUL!');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainNavigationScreen())
        );
      }
    } on FirebaseAuthException catch (e) {
      _handleSignInError(e);
    } catch (e) {
      _showSnackBar('AN UNEXPECTED ERROR OCCURRED: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Utility methods for cleaner code
  void _setLoading(bool state) {
    if (mounted) {
      setState(() => _isLoading = state);
    }
  }
  
  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  void _handleSignInError(FirebaseAuthException e) {
    String message;
    if (e.code == 'USER_NOT_FOUND' || e.code == 'WRONG_PASSWORD') {
      message = 'INVALID LOGIN CREDENTIALS.';
    } else if (e.code == 'INVALID_EMAIL') {
      message = 'THE EMAIL ADDRESS IS NOT VALID.';
    } else {
      message = e.message ?? 'AN UNKNOWN AUTHENTICATION ERROR OCCURRED.';
    }
    _showSnackBar(message);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 3. Widget Build Method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('SKILL WAVES', style: TextStyle(fontWeight: FontWeight.bold, )),
        backgroundColor: _screenBackgroundColor,
        elevation: 0, 
      ),
      backgroundColor: _screenBackgroundColor,
      body: SafeArea(
        // Use a Column for the body to stack the scrollable content and the fixed button
        child: Column(
          children: [
            // SCROLLABLE CONTENT AREA (Takes up remaining space)
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [
                    const SizedBox(height: 60),
                    
                    // 1. Illustration (Placeholder)
                    const Center(child: _IllustrationArea(height: 120)), 
                    
                    const SizedBox(height: 30),
                    
                    // 2. Title & Subtitle
                    Text( "LOGIN", style: const TextStyle( fontSize: 24, fontWeight: FontWeight.bold, color: _primaryColor)),
                    const SizedBox(height: 4),
                    Text( "PLEASE SIGN IN TO CONTINUE.", style: TextStyle( fontSize: 14, color: _textColor)),
                    
                    const SizedBox(height: 24),
                    
                    // 3. Email Field
                    _CustomTextField(
                      controller: _emailController,
                      icon: Icons.email_outlined, 
                      hintText: 'EMAIL ADDRESS',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // 4. Password Field
                    _PasswordField(
                      controller: _passwordController,
                      obscurePassword: _obscurePassword,
                      onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    
                    const SizedBox(height: 10),
        
                    // 5. Forgot Password (Aligned right)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end, 
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordScreen())),
                          child: const Text(
                            "FORGOT PASSWORD ?", 
                            textAlign: TextAlign.right, 
                            style: TextStyle(
                              color: _primaryColor, 
                              fontWeight: FontWeight.bold, 
                              fontSize: 12, 
                            )
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 40), 

                    // 6. OR Divider
                    const _OrDivider(),
                    
                    const SizedBox(height: 24),
                    
                    // 7. Social Login Buttons
                    const Center(child: _SocialLoginButtons()),
                    
                    const SizedBox(height: 40),
                    
                    // 8. Sign Up Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("DON'T HAVE ACCOUNT? ", style: TextStyle(color: _textColor, fontSize: 14)),
                        GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen())),
                          child: const Text("SIGN UP", style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold, fontSize: 14)),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            
            // FIXED BUTTON AREA (Pushed to the bottom)
            Padding(
              padding: const EdgeInsets.fromLTRB(28.0, 10.0, 28.0, 20.0), // Added bottom padding

              child: _ActionButton(
                label: 'SIGN IN',
                onPressed: _signIn,
                isLoading: _isLoading,
                borderRadius: 30, 
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// WIDGET COMPONENTS (Unchanged)
// =========================================================================

class _IllustrationArea extends StatelessWidget {
  final double height;
  const _IllustrationArea({required this.height});

  @override
  Widget build(BuildContext context) {
    
    return SizedBox(
      height: height,
      child: Image.asset(
        'assets/images/login_signup.png',
        height: 120,
        fit: BoxFit.contain,
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;

  const _CustomTextField({
    required this.icon,
    required this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _fieldBackgroundColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: _primaryColor),
        decoration: InputDecoration(
          hintText: hintText, 
          hintStyle: TextStyle(color: Colors.black.withOpacity(0.3), fontSize: 15, fontWeight: FontWeight.w600),
          prefixIcon: Icon(icon, color: _textColor, size: 22),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20), 
          border: _inputBorder,
          enabledBorder: _inputBorder,
          focusedBorder: _focusedInputBorder,
        ),
      ),
    );
  }

  static const InputBorder _inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(30)),
    borderSide: BorderSide.none,
  );
  
  static final InputBorder _focusedInputBorder = OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(30)),
    borderSide: BorderSide(color: _primaryColor, width: 1.5),
  );
}

class _PasswordField extends StatelessWidget {
  final bool obscurePassword;
  final VoidCallback onToggle;
  final TextEditingController? controller;

  const _PasswordField({
    required this.obscurePassword,
    required this.onToggle,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _fieldBackgroundColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscurePassword,
        style: const TextStyle(color: _primaryColor),
        decoration: InputDecoration(
          hintText: 'PASSWORD',
          hintStyle: const TextStyle(color: Color(0xFFB0B8C1), fontSize: 15, fontWeight: FontWeight.w600),
          prefixIcon: Icon(Icons.lock_outline, color: _textColor, size: 22),
          suffixIcon: IconButton(
            icon: Icon(
              obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: _textColor,
              size: 22,
            ),
            onPressed: onToggle,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          border: _CustomTextField._inputBorder,
          enabledBorder: _CustomTextField._inputBorder,
          focusedBorder: _CustomTextField._focusedInputBorder,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double borderRadius;

  const _ActionButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.borderRadius = 28,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 150, 
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.zero, 
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
              )
            : Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(child: Divider(color: Colors.grey, height: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text("OR", style: TextStyle(color: _textColor, fontSize: 14, fontWeight: FontWeight.w500)),
        ),
        const Expanded(child: Divider(color: Colors.grey, height: 1)),
      ],
    );
  }
}

class _SocialLoginButtons extends StatelessWidget {
  const _SocialLoginButtons();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SocialButton(
          icon: Image.asset('assets/images/google.png', height: 34, width: 34),
          onPressed: () => debugPrint('Google login pressed'), 
        ),
        const SizedBox(width: 20),
        _SocialButton(
          icon: Image.asset('assets/images/github.png', height: 34, width: 34),
          onPressed: () => debugPrint('GitHub login pressed'), 
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onPressed;

  const _SocialButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50, 
      height: 50, 
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withOpacity(0.1),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        padding: EdgeInsets.zero,
      ),
    );
  }
}