import 'package:flutter/material.dart';
import 'package:grade_learn/auth/signin_page.dart';
import 'package:grade_learn/auth/signup_page.dart';

// COLORS
const Color kPrimary = Color(0xFF282D31);
const Color kSecondary = Color(0xFF7E7FD7);

// MODEL
class OnboardingData {
  final String image;
  final String title;
  final String subtitle;

  OnboardingData(this.image, this.title, this.subtitle);
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController controller = PageController();
  int index = 0;

  final pages = [
    OnboardingData(
      'assets/images/onboarding1.png',
      'A GUIDANCE IN YOUR POCKET',
      'SAVE YOUR TIME WITH SMART GUIDANCE',
    ),
    OnboardingData(
      'assets/images/onboarding2.png',
      'LEARN WITH CLARITY',
      'COURSES, MENTORS AND SKILLS IN ONE APP',
    ),
    OnboardingData(
      'assets/images/onboarding3.png',
      'EVERYTHING IN ONE PLACE',
      'LEARN, SHOP AND GROW WITH SKILLWAVE',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFF9),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFF9),
        title: const Text('SKILL WAVES'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: controller,
                    itemCount: pages.length,
                    onPageChanged: (i) => setState(() => index = i),
                    itemBuilder: (_, i) => _PageContent(data: pages[i]),
                  ),
                ),
                _BottomSection(
                  isLast: index == pages.length - 1,
                  onNext: () => controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// PAGE CONTENT
class _PageContent extends StatelessWidget {
  final OnboardingData data;
  const _PageContent({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(data.image, height: 340),
          const SizedBox(height: 30),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            data.subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

// BOTTOM SECTION
class _BottomSection extends StatelessWidget {
  final bool isLast;
  final VoidCallback onNext;

  const _BottomSection({
    required this.isLast,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: isLast
          ? Row(
              children: [
                _Button(
                  text: 'LOGIN',
                  filled: false,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  ),
                ),
                const SizedBox(width: 16),
                _Button(
                  text: 'SIGN UP',
                  filled: true,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignUpScreen()),
                  ),
                ),
              ],
            )
          : _Button(
              text: 'NEXT',
              filled: true,
              onTap: onNext,
            ),
    );
  }
}

// BUTTON
class _Button extends StatelessWidget {
  final String text;
  final bool filled;
  final VoidCallback onTap;

  const _Button({
    required this.text,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: filled ? kPrimary : Colors.white,
            foregroundColor: filled ? Colors.white : kPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: filled ? BorderSide.none : const BorderSide(color: kPrimary),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
