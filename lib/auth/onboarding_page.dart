import 'package:flutter/material.dart';
import 'package:grade_learn/auth/signin_page.dart';
import 'package:grade_learn/auth/signup_page.dart';

// --- Placeholder for Route Navigation ---
class MyRoutes {
  static const String homeRoute = '/home';
  static const String onboardingRoute = '/onboarding';
}

// --- DATA MODEL for Onboarding Content ---
class OnboardingModel {
  final String illustrationPath;
  final String title;
  final String subtitle;

  OnboardingModel({
    required this.illustrationPath,
    required this.title,
    required this.subtitle,
  });
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final Color _primaryColor = const Color(0xFF282D31);
  final Color _secondaryColor = const Color(0xFF7E7FD7);

  final List<OnboardingModel> _pages = [
    OnboardingModel(
      illustrationPath: 'assets/images/onboarding1.png',
      title: 'A shop in your pocket.',
      subtitle:
          "We’re very lucky to find you! With Shoppy we can save your lovely time.",
    ),
    OnboardingModel(
      illustrationPath: 'assets/images/onboarding2.png',
      title: 'Everything can be find!',
      subtitle: "With Shoppy we will not let you be confused. Enjoy shopping!",
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    Navigator.pushReplacementNamed(context, MyRoutes.homeRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // --- Onboarding Slides ---
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return _OnboardingPageContent(
                        data: _pages[index],
                        primaryColor: _primaryColor,
                      );
                    },
                  ),
                ),

                // --- Bottom Nav Section ---
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 0, 28, 40),
                  child: _buildNavigationArea(),
                ),
              ],
            ),

            // --- Back Arrow ---
            if (_currentPage > 0)
              Positioned(
                top: 20,
                left: 20,
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 0, 0, 0)),
                    onPressed: () {
                      if (_currentPage > 0) {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // --- Page Indicator ---
  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_pages.length, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          height: 8.0,
          width: _currentPage == index ? 24.0 : 8.0,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? _primaryColor
                : _secondaryColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }

  // --- Navigation Buttons & Indicators ---
  Widget _buildNavigationArea() {
    final bool isLastPage = _currentPage == _pages.length - 1;
    Widget indicator = _buildPageIndicator();

    if (isLastPage) {
      return Column(
        children: [
          indicator,
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: 'Login',
                  isPrimary: false,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _ActionButton(
                  label: 'Sign up',
                  isPrimary: true,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
                  },
                ),
              ),
            ],
          ),
        ],
      );
    }

    // --- For first page ---
    return Column(
      children: [
        indicator,
        const SizedBox(height: 32),
        _ActionButton(
          label: 'Next',
          isPrimary: true,
          onPressed: () => _pageController.nextPage(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          ),
        ),
      ],
    );
  }
}

// --- PAGE CONTENT ---
class _OnboardingPageContent extends StatelessWidget {
  final OnboardingModel data;
  final Color primaryColor;

  const _OnboardingPageContent({
    required this.data,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Illustration
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.45,
            child: Center(
              child: Image.asset(
                data.illustrationPath,
                height: MediaQuery.of(context).size.height * 0.4,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Text(
                      "Image Not Found\n(Check assets path)",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 32),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            data.subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.black54,
                  height: 1.4,
                ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// --- ACTION BUTTON ---
class _ActionButton extends StatelessWidget {
  final String label;
  final bool isPrimary;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.isPrimary,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF282D31);
    final bool isLoginButton = label.toLowerCase() == 'login';
    final Color textColor = isLoginButton ? Colors.black : Colors.white;

    return SizedBox(
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? primaryColor : Colors.white,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: isPrimary
                ? BorderSide.none
                : BorderSide(color: primaryColor, width: 1.5),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
