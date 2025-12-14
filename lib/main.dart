import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // <<<--- 1. NEW IMPORT

import 'package:grade_learn/models/chatbot.dart';
import 'package:grade_learn/chat/chatbot_provider.dart';
import 'firebase_options.dart';
import 'package:grade_learn/auth/forgotpassword_page.dart';
import 'package:grade_learn/auth/onboarding_page.dart';
import 'package:grade_learn/auth/signin_page.dart';
import 'package:grade_learn/auth/signup_page.dart';
import 'package:grade_learn/pages/chatwelcome_page.dart';
import 'package:grade_learn/pages/home_page.dart';
import 'package:grade_learn/pages/internship_page.dart';
import 'package:grade_learn/pages/skill_page.dart';
import 'package:grade_learn/widgets/main_navigation_screen.dart';
import 'routes/routes.dart' as app_routes;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");

  // The application is now wrapped in ProviderScope to allow
  // Riverpod widgets (like the CourseDetailScreen) to function.
  runApp(
    ProviderScope( // <<<--- 2. RIVERPOD SCOPE ADDED HERE
      child: ChangeNotifierProvider<ChatbotProvider>(
        create: (context) => ChatbotProvider(),
        child: const MyApp(),
      ),
    ),
  );
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
        useMaterial3: true,
      ),
      home: const OnboardingPage(),
      routes: {
        '/home': (context) => const HomePage(),
        app_routes.MyRoutes.OnboardingPageRoute: (context) =>
            const OnboardingPage(),
        app_routes.MyRoutes.SignUpScreenRoute: (context) => const SignUpScreen(),
        app_routes.MyRoutes.LoginScreenRoute: (context) => const LoginScreen(),
        app_routes.MyRoutes.ForgotPasswordScreenRoute: (context) =>
            const ForgotPasswordScreen(),
        app_routes.MyRoutes.InternshipPageRoute: (context) =>
            const InternshipPage(),
        app_routes.MyRoutes.navbarRoute: (context) =>
            const MainNavigationScreen(),
        app_routes.MyRoutes.SkillPageRoute: (context) => const SkillPage(),
        app_routes.MyRoutes.ChatWelcomeRoute: (context) => const ChatWelcome(),
        app_routes.MyRoutes.ChatBotRoute: (context) => const ChatBotPage(),
        app_routes.MyRoutes.ProfileAppRoutes: (context) =>
            const PlaceholderPage(title: 'Profile'),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text(
                "404 - Page Not Found",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        );
      },
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('This is the $title page.')),
    );
  }
}