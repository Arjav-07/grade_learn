import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _rememberMe = false;
  bool _obscurePassword = true;

  // --- COLOR PALETTE ---
  final Color _primaryColor = Colors.black87;
  final Color _textColor = const Color(0xFF64748B);

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
                _IllustrationArea(),
                
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
                  icon: Icons.person_outline,
                  hintText: 'Username',
                  primaryColor: _primaryColor,
                ),
                
                const SizedBox(height: 16),
                
                _CustomTextField(
                  icon: Icons.phone_outlined,
                  hintText: 'Mobile Number',
                  primaryColor: _primaryColor,
                ),
                
                const SizedBox(height: 16),
                
                _PasswordField(
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
                      "Reminder me nexttime",
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
                  onPressed: () {
                    // Handle sign up
                  },
                ),
                
                const SizedBox(height: 24),
                
                // 7. OR Divider
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
                
                // 8. Social Login Buttons
                _SocialLoginButtons(),
                
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

// --- ILLUSTRATION AREA ---

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

// --- SOCIAL LOGIN BUTTONS ---

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
            // Handle Google sign up
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
            // Handle GitHub sign up
            print('GitHub sign up pressed');
          },
        ),
        const SizedBox(width: 20),
        _SocialButton(
          icon: const Icon(Icons.apple, color: Colors.black, size: 28),
          onPressed: () {
            // Handle Apple sign up
            print('Apple sign up pressed');
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

  const _CustomTextField({
    required this.icon,
    required this.hintText,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
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

// --- PASSWORD FIELD WITH TOGGLE ---

class _PasswordField extends StatelessWidget {
  final bool obscurePassword;
  final Color primaryColor;
  final VoidCallback onToggle;

  const _PasswordField({
    required this.obscurePassword,
    required this.primaryColor,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
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

// --- ACTION BUTTON ---

class _ActionButton extends StatelessWidget {
  final String label;
  final Color primaryColor;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.primaryColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Text(
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