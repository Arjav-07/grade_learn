import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
 // ⭐️ ADDED: Import for the Chatbot Provider
import 'package:grade_learn/models/chatbot.dart'; // ⭐️ ADDED: Import for the new chat screen
import 'package:provider/provider.dart'; // ⭐️ ADDED: Import for the Provider package
import 'firebase_options.dart';

// --- AUTH SCREENS ---
import 'package:grade_learn/auth/forgotpassword_page.dart';
import 'package:grade_learn/auth/onboarding_page.dart';
import 'package:grade_learn/auth/signin_page.dart';
import 'package:grade_learn/auth/signup_page.dart';

// --- APP PAGES ---
// import 'package:grade_learn/models/chatbot.dart'; // ⭐️ REMOVED: Old chatbot UI import
import 'package:grade_learn/pages/chatwelcome_page.dart';
import 'package:grade_learn/pages/home_page.dart';
import 'package:grade_learn/pages/internship_page.dart';
import 'package:grade_learn/pages/skill_page.dart';
import 'package:grade_learn/widgets/main_navigation_screen.dart';

// --- ROUTES ---
import 'routes/routes.dart' as app_routes;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase before running the app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");

  // ⭐️ UPDATED: Wrapped the app with Provider (CareerAdvisorChat is not a ChangeNotifier)
    runApp(
      Provider<CareerAdvisorChat>(
        create: (context) => CareerAdvisorChat(),
        child: const MyApp(),
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

      // 🏠 Initial screen
      home: const MainNavigationScreen(),

      // 📚 Named routes
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
        // ⭐️ UPDATED: The ChatBotRoute now points to your new themed, conversational screen
        app_routes.MyRoutes.ChatBotRoute: (context) => const CareerAdvisorChat(),
        app_routes.MyRoutes.ProfileAppRoutes: (context) =>
            const PlaceholderPage(title: 'Profile'),
      },

      // 🚫 Handle undefined routes
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

// Added a placeholder for the page that was missing in the original file
class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text('This is the $title page.'),
      ),
    );
  }
}