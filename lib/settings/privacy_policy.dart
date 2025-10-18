// privacy_policy.dart

import 'package:flutter/material.dart';

// --- UI Constants for consistent theming ---
const Color kBackgroundColor = Color(0xFFF7F7F9);
const Color kDarkTextColor = Color(0xFF282C35);
const Color kSecondaryTextColor = Color(0xFF6c757d); // A slightly darker grey for readability
const Color kPrimaryColor = Color(0xFF7A64D8);

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kDarkTextColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Privacy Policy',
          style: TextStyle(color: kDarkTextColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        children: [
          // --- Header Section ---
          const Text(
            'Last updated: October 18, 2025',
            style: TextStyle(
              color: kSecondaryTextColor,
              fontStyle: FontStyle.italic,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          _buildParagraph(
            'Welcome to Grade Learn ("we", "us", or "our"). We are committed to protecting your personal information and your right to privacy. If you have any questions or concerns about this privacy notice, or our practices with regards to your personal information, please contact us.',
          ),
          const SizedBox(height: 24),

          // --- Policy Sections ---
          _buildSectionHeader('1. Information We Collect'),
          _buildParagraph(
            'We collect personal information that you voluntarily provide to us when you register on the app, express an interest in obtaining information about us or our products and services, when you participate in activities on the app or otherwise when you contact us.',
          ),
          _buildParagraph(
            'The personal information that we collect depends on the context of your interactions with us and the app, the choices you make and the products and features you use. The personal information we collect may include the following:',
          ),
          _buildListItem('Personal Information Provided by You: Names; email addresses; usernames; passwords.'),
          _buildListItem('Usage Data: We may also collect information that your device sends whenever you use our app, such as your device\'s IP address, device type, operating system version, and the time and date of your use.'),
          const SizedBox(height: 24),
          
          _buildSectionHeader('2. How We Use Your Information'),
          _buildParagraph(
            'We use personal information collected via our app for a variety of business purposes described below. We process your personal information for these purposes in reliance on our legitimate business interests, in order to enter into or perform a contract with you, with your consent, and/or for compliance with our legal obligations.',
          ),
          _buildListItem('To facilitate account creation and logon process.'),
          _buildListItem('To post testimonials with your consent.'),
          _buildListItem('To manage user accounts and keep them in working order.'),
          _buildListItem('To send administrative information to you.'),
          const SizedBox(height: 24),

          _buildSectionHeader('3. Information Sharing and Disclosure'),
          _buildParagraph(
            'We only share information with your consent, to comply with laws, to provide you with services, to protect your rights, or to fulfill business obligations. We do not sell, rent, or trade any of your personal information with any third parties for their promotional purposes.',
          ),
          const SizedBox(height: 24),

          _buildSectionHeader('4. Data Security'),
          _buildParagraph(
            'We have implemented appropriate technical and organizational security measures designed to protect the security of any personal information we process. However, despite our safeguards and efforts to secure your information, no electronic transmission over the Internet or information storage technology can be guaranteed to be 100% secure.',
          ),
          const SizedBox(height: 24),

          _buildSectionHeader('5. Children\'s Privacy'),
          _buildParagraph(
            'Our service does not address anyone under the age of 13. We do not knowingly collect personally identifiable information from children under 13. In the case we discover that a child under 13 has provided us with personal information, we immediately delete this from our servers.',
          ),
          const SizedBox(height: 24),

          _buildSectionHeader('6. Changes to This Privacy Policy'),
          _buildParagraph(
            'We may update this privacy notice from time to time. The updated version will be indicated by an updated "Last updated" date and the updated version will be effective as soon as it is accessible. We encourage you to review this privacy notice frequently to be informed of how we are protecting your information.',
          ),
          const SizedBox(height: 24),
          
          _buildSectionHeader('7. Contact Us'),
          _buildParagraph(
            'If you have questions or comments about this notice, you may email us at support@gradelearnapp.com or by post to:',
          ),
          const SizedBox(height: 8),
          _buildParagraph(
            'Grade Learn Inc.\n123 Learning Lane\nEducation City, ED 45678\nIndia'
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  /// Helper widget to build a styled section header.
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: kDarkTextColor,
        ),
      ),
    );
  }

  /// Helper widget to build a styled paragraph.
  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: kSecondaryTextColor,
          height: 1.5, // Line spacing for better readability
        ),
      ),
    );
  }

  /// Helper widget to build a styled list item.
  Widget _buildListItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              fontSize: 16,
              color: kSecondaryTextColor,
              height: 1.5,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: kSecondaryTextColor,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}