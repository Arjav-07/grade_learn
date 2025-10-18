// terms_and_conditions.dart

import 'package:flutter/material.dart';

// --- UI Constants for consistent theming ---
const Color kBackgroundColor = Color(0xFFF7F7F9);
const Color kDarkTextColor = Color(0xFF282C35);
const Color kSecondaryTextColor = Color(0xFF6c757d);
const Color kPrimaryColor = Color(0xFF7A64D8);

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

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
          'Terms and Conditions',
          style: TextStyle(color: kDarkTextColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        children: [
          // --- Header Section ---
          const Text(
            'Effective Date: October 18, 2025',
            style: TextStyle(
              color: kSecondaryTextColor,
              fontStyle: FontStyle.italic,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          _buildParagraph(
            'Please read these Terms and Conditions ("Terms") carefully before using the Grade Learn mobile application (the "Service") operated by Grade Learn Inc. ("us", "we", or "our").',
          ),
          const SizedBox(height: 24),

          // --- Policy Sections (Placeholder Content) ---
          _buildSectionHeader('1. Agreement to Terms'),
          _buildParagraph(
            'By accessing or using our Service, you agree to be bound by these Terms. If you disagree with any part of the terms, then you may not access the Service. This is a legally binding agreement.',
          ),
          const SizedBox(height: 24),

          _buildSectionHeader('2. Accounts'),
          _buildParagraph(
            'When you create an account with us, you must provide us with information that is accurate, complete, and current at all times. Failure to do so constitutes a breach of the Terms, which may result in immediate termination of your account on our Service.',
          ),
          _buildParagraph(
            'You are responsible for safeguarding the password that you use to access the Service and for any activities or actions under your password. You agree not to disclose your password to any third party.',
          ),
          const SizedBox(height: 24),

          _buildSectionHeader('3. Intellectual Property'),
          _buildParagraph(
            'The Service and its original content, features, and functionality are and will remain the exclusive property of Grade Learn Inc. and its licensors. The Service is protected by copyright, trademark, and other laws of both India and foreign countries.',
          ),
          const SizedBox(height: 24),

          _buildSectionHeader('4. Prohibited Uses'),
          _buildParagraph(
            'You agree not to use the Service in any way that:',
          ),
          _buildListItem('Is unlawful, illegal, fraudulent, or harmful.'),
          _buildListItem('Harasses, abuses, insults, harms, defames, or discriminates based on gender, sexual orientation, religion, ethnicity, race, age, national origin, or disability.'),
          _buildListItem('Infringes upon or violates our intellectual property rights or the intellectual property rights of others.'),
          _buildListItem('Submits false or misleading information.'),
          const SizedBox(height: 24),

          _buildSectionHeader('5. Termination'),
          _buildParagraph(
            'We may terminate or suspend your account immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach the Terms. Upon termination, your right to use the Service will immediately cease.',
          ),
          const SizedBox(height: 24),
          
          _buildSectionHeader('6. Governing Law'),
          _buildParagraph(
            'These Terms shall be governed and construed in accordance with the laws of India, without regard to its conflict of law provisions. Our failure to enforce any right or provision of these Terms will not be considered a waiver of those rights.',
          ),
          const SizedBox(height: 24),

          _buildSectionHeader('7. Changes to Terms'),
          _buildParagraph(
            'We reserve the right, at our sole discretion, to modify or replace these Terms at any time. We will provide at least 30 days\' notice prior to any new terms taking effect. By continuing to access or use our Service after those revisions become effective, you agree to be bound by the revised terms.',
          ),
          const SizedBox(height: 24),

          _buildSectionHeader('8. Contact Us'),
          _buildParagraph(
            'If you have any questions about these Terms, please contact us at support@gradelearnapp.com.',
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