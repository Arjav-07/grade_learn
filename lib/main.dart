// --- REVISED main.dart ---

import 'package:flutter/material.dart';
import 'package:grade_learn/auth/forgotpassword_page.dart';
import 'package:grade_learn/auth/onboarding_page.dart';
import 'package:grade_learn/auth/signin_page.dart';
import 'package:grade_learn/auth/signup_page.dart';
import 'package:grade_learn/pages/home_page.dart';
import 'package:grade_learn/widgets/main_navigation_screen.dart';

import 'pages/skill_page.dart';
import 'routes/routes.dart' as app_routes;
// ... other imports

// You'll need to import the MainNavigationScreen here
// import 'path_to_your_file/main_navigation_screen.dart'; 


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grade Learn',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // 1. Set the initial screen to the main navigation shell
      home: const MainNavigationScreen(), // Use MainNavigationScreen here

      routes: {
        '/home': (context) => const HomePage(),
        app_routes.MyRoutes.OnboardingPageRoute: (context) => const OnboardingPage(),
        app_routes.MyRoutes.SignUpScreenRoute: (context) => const SignUpScreen(),
        app_routes.MyRoutes.LoginScreenRoute: (context) => const LoginScreen(),
        app_routes.MyRoutes.ForgotPasswordScreenRoute: (context) => const ForgotPasswordScreen(),
        
        // 2. The NavBar route should now also point to the main navigation shell
        app_routes.MyRoutes.navbarRoute: (context) => const MainNavigationScreen(),
        
        app_routes.MyRoutes.SkillPageRoute: (context) => const SkillPage(),
      },
      onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => const Scaffold(
              body: Center(child: Text("404 - Page Not Found")),
            ),
          );
      },
    );
  }
}