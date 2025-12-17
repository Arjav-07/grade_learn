import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grade_learn/services/user_service.dart'; 

// --- Global Constants for Styling ---
const Color _primaryColor = Colors.black87;
final Color _textColor = Colors.black.withOpacity(0.5);
const Color _fieldBackgroundColor = Color(0xFFF8F9FA);
const Color _screenBackgroundColor = Color(0xFFFFFFF9);

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // 1. Controllers and Services
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserService _userService = UserService();

  bool _obscurePassword = true;
  bool _isLoading = false; 

  // 2. Firebase Sign Up Logic (Two-Step Process)
  Future<void> _signUp() async {
    // Basic local validation
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty || _usernameController.text.isEmpty) {
      _showSnackBar('PLEASE FILL IN ALL FIELDS.');
      return;
    }

    _setLoading(true);

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final username = _usernameController.text.trim();

    try {
      // Step 1: Create user in Firebase Authentication
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (user != null) {
        // Step 2: Save the user profile data to Firestore
        await _userService.createUserProfile(
          uid: user.uid,
          username: username,
          email: email,
        );

        // Success: Navigate back to the login screen
        if (mounted) {
            _showSnackBar('REGISTRATION SUCCESSFUL! YOU CAN NOW SIGN IN.');
            Navigator.pop(context); 
        }
      }
    } on FirebaseAuthException catch (e) {
      _handleSignUpAuthError(e);
    } catch (e) {
      // Catch errors during Firestore write or general unexpected errors
      _showSnackBar('AN UNEXPECTED ERROR OCCURRED: $e');
      // Attempt to clean up the Auth user if profile write failed
      if (FirebaseAuth.instance.currentUser?.uid != null) {
         FirebaseAuth.instance.currentUser?.delete();
      }
    } finally {
      _setLoading(false);
    }
  }

  // --- Utility Methods ---
  void _setLoading(bool state) {
    if (mounted) setState(() => _isLoading = state);
  }
  
  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  void _handleSignUpAuthError(FirebaseAuthException e) {
    String message;
    if (e.code == 'WEAK_PASSWORD') {
      message = 'THE PASSWORD PROVIDED IS TOO WEAK (MIN 6 CHARACTERS).';
    } else if (e.code == 'EMAIL_ALREADY_IN_USE') {
      message = 'AN ACCOUNT ALREADY EXISTS FOR THAT EMAIL.';
    } else if (e.code == 'INVALID_EMAIL') {
      message = 'THE EMAIL ADDRESS IS NOT VALID.';
    } else {
      message = e.message ?? 'AN UNKNOWN REGISTRATION ERROR OCCURRED.';
    }
    _showSnackBar(message);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 3. Widget Build Method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true, 
        title: const Text('SKILL WAVES', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: _screenBackgroundColor,
        elevation: 0, 
      ),
      backgroundColor: _screenBackgroundColor,
      body: SafeArea(
        // The main body is now a single Column wrapped in Padding.
        // It uses a Spacer to push the action button down, but relies on 
        // the screen size to fit the content.
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0), 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
              // --- FORM CONTENT ---
              const SizedBox(height: 40), 
              
              // 1. Illustration (Placeholder)
              const Center(child: _IllustrationArea()),
              
              const SizedBox(height: 30), 
              
              // 2. Title & Subtitle
              Text( "REGISTER", style: const TextStyle( fontSize: 24, fontWeight: FontWeight.bold, color: _primaryColor)),
              const SizedBox(height: 4),
              Text( "PLEASE REGISTER TO LOGIN.", style: TextStyle( fontSize: 14, color: _textColor)),
              
              const SizedBox(height: 24),
              
              // 3. Username Field
              _CustomTextField(
                controller: _usernameController,
                icon: Icons.person_outline, 
                hintText: 'USERNAME',
              ),
              
              const SizedBox(height: 16),
              
              // 4. Email Field
              _CustomTextField(
                controller: _emailController,
                icon: Icons.email_outlined, 
                hintText: 'EMAIL ADDRESS',
                keyboardType: TextInputType.emailAddress,
              ),
              
              const SizedBox(height: 16),
              
              // 5. Password Field
              _PasswordField(
                controller: _passwordController,
                obscurePassword: _obscurePassword,
                onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
              
              // --- SPACER (Pushes content up and footer down) ---
              const Spacer(), 

              // --- FOOTER/ACTION AREA ---
              
              const SizedBox(height: 10), // Add a small space before the divider

              // 6. OR Divider
              const _OrDivider(),
              
              const SizedBox(height: 24),
              
              // 7. Social Login Buttons
              const Center(child: _SocialLoginButtons()),
              
              const SizedBox(height: 30),
              
              // 8. Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("ALREADY HAVE ACCOUNT? ", style: TextStyle(color: _textColor, fontSize: 14)),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text("SIGN IN", style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // 9. SIGN UP Button
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0), // Consistent bottom padding
                  child: _ActionButton(
                    label: 'SIGN UP',
                    onPressed: _signUp,
                    isLoading: _isLoading,
                    borderRadius: 30, 
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =========================================================================
// WIDGET COMPONENTS (Unchanged)
// =========================================================================

class _IllustrationArea extends StatelessWidget {
  const _IllustrationArea();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120, 
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
    required this.icon, required this.hintText,
    this.controller, this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    const InputBorder inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      borderSide: BorderSide.none,
    );
    final InputBorder focusedInputBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(30)),
      borderSide: BorderSide(color: _primaryColor, width: 1.5),
    );

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
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), 
          border: inputBorder,
          enabledBorder: inputBorder,
          focusedBorder: focusedInputBorder,
        ),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final bool obscurePassword;
  final VoidCallback onToggle;
  final TextEditingController? controller;

  const _PasswordField({
    required this.obscurePassword,
    required this.onToggle, this.controller,
  });

  @override
  Widget build(BuildContext context) {
    const InputBorder inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      borderSide: BorderSide.none,
    );
    final InputBorder focusedInputBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(30)),
      borderSide: BorderSide(color: _primaryColor, width: 1.5),
    );
    
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
          hintStyle: TextStyle(color: Colors.black.withOpacity(0.3), fontSize: 15, fontWeight: FontWeight.w600),
          prefixIcon: Icon(Icons.lock_outline, color: _textColor, size: 22),
          suffixIcon: IconButton(
            icon: Icon(
              obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: _textColor,
              size: 22,
            ),
            onPressed: onToggle,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          border: inputBorder,
          enabledBorder: inputBorder,
          focusedBorder: focusedInputBorder,
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
    required this.label, required this.onPressed,
    this.isLoading = false, this.borderRadius = 30,
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
                width: 20, height: 20,
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