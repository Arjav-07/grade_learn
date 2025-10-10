import 'package:flutter/material.dart';
import 'package:grade_learn/models/chatbot.dart';

// --- Color Constants (Moved to top-level for accessibility) ---
const Color kPrimaryGreen = Color(0xFF7A64D8); 
const Color kPrimaryPurple = Color(0xFF5A2A8F); // New color for logo and nav icons
const Color kBackgroundColor = Color(0xFFF7F7F9); // Slight off-white or light background
const Color kDarkTextColor = Color(0xFF282C35); 
const Color kLightTextColor = Color(0xFF6C757D); 


class ChatWelcome extends StatelessWidget {
  const ChatWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine screen height for proportional spacing
    final double screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      
      backgroundColor: kBackgroundColor,
      // REMOVED: bottomNavigationBar: _buildBottomNavBar(),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header (Logo and Title)
            _buildHeader(),
            
            // Add spacing to push content down (Increased spacing since no bottom bar)
            SizedBox(height: screenHeight * 0.15), 
            
            // 2. Main Content (Centered)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Column(
                    // mainAxisAlignment.center is necessary for vertical alignment inside Center
                    // Changed to mainAxisAlignment.start to place content higher since the Spacer is removed
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Large Squircle Logo 
                      _buildLargeLogo(),
                      const SizedBox(height: 50),
                      
                      // Welcome Text
                      _buildWelcomeText(),
                      const SizedBox(height: 10),

                      // Subtitle
                      _buildSubtitle(),
                      
                      // --- EDITED: Removed large SizedBox and replaced with small gap ---
                      const SizedBox(height: 40), 

                      // 3. Bottom Button (Moved here, inside the Expanded/Center block)
                      _buildStartChatButton(context),
                      
                      // REMOVED: Use a Spacer to push the content block up, away from the bottom navigation bar
                    ],
                  ),
                ),
              ),
            ),
            
            // Removed the old button call here, as it's now inside the Expanded widget
            // The bottom nav bar handles the rest of the padding
            const SizedBox(height: 10), 
          ],
        ),
      ),
    );
  }

  // --- Widget Builders ---

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Small Logo Icon (Left) - Using the purple theme from the new image
          const Spacer(),
          // App Title (Center)
          const Text(
            'Grade Learn',
            
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: kDarkTextColor,
            ),
          ),
          
          const Spacer(),
          // Spacer for alignment (Right)
          const SizedBox(width: 28), 
        ],
        
      ),
    );
  }

  Widget _buildLargeLogo() {
    // This widget is completely redesigned to match the second image's squircle logo.
    return Container(
      width: 150,
      height: 150,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: kPrimaryGreen.withOpacity(0.1), 
        borderRadius: BorderRadius.circular(35), // Rounded corners for the light container
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25), // More rounded corners for the inner container
          
        ),
        child: Center(
          // Using a suitable icon to represent the logo design
          child: Icon(
            Icons.science, // Placeholder for the atom swirl logo
            size: 60,
            color: kPrimaryGreen, // Use the primary green for the icon color
          ),
        ),
      ),
    );
  }
  
  Widget _buildWelcomeText() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: kDarkTextColor,
          height: 1.2,
        ),
        children: [
          const TextSpan(text: 'Welcome to\n'),
          TextSpan(
            text: 'Grade Learn ',
            style: TextStyle(
              color: kPrimaryGreen,
            ),
          ),
          const TextSpan(text: '👋'),
        ],
      ),
    );
  }

  Widget _buildSubtitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        'Get instant answers to your questions, personalized learning support, and more.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          color: kLightTextColor,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildStartChatButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CareerAdvisorChat()),
            );
            // Action for starting the chat
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryGreen,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30), // Fully rounded edges
            ),
            elevation: 8,
            shadowColor: kPrimaryGreen.withOpacity(0.5),
          ),
          child: const Text(
            'Start Chat',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
  
  // REMOVED: _buildBottomNavBar() and _buildNavItem() are no longer needed.
}