// help_center.dart

import 'package:flutter/material.dart';

// --- UI Constants for consistent theming ---
const Color kBackgroundColor = Color(0xFFF7F7F9);
const Color kPrimaryColor = Color(0xFF7A64D8);
const Color kDarkTextColor = Color(0xFF282C35);
const Color kSecondaryTextColor = Colors.grey;
const Color kCardBackgroundColor = Colors.white;

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  // Controller to manage the text in the search field
  final _searchController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the tree
    _searchController.dispose();
    super.dispose();
  }
  
  // --- Dummy data for the FAQ section ---
  final Map<String, String> _accountFaqs = {
    'How do I change my username or profile picture?': 
      'You can update your personal information by navigating to the Settings page and selecting "Edit Profile". From there, you can enter a new username and choose a new avatar.',
    'How do I reset my password?':
      'To reset your password, you must first log out. On the login screen, tap the "Forgot Password?" link. You will receive an email with instructions to set a new password.',
    'How do I delete my account?':
      'Account deletion is permanent. If you wish to proceed, please contact our support team through the "Contact Support" button on this page, and they will assist you with the process.'
  };

  final Map<String, String> _billingFaqs = {
    'What payment methods do you accept?':
      'We accept all major credit and debit cards, including Visa, MasterCard, and American Express. We also support payments through PayPal.',
    'How do I cancel my subscription?':
      'You can manage your subscription by going to Settings > Payment Methods. There you will find an option to cancel your active subscription. Your premium access will continue until the end of the current billing period.',
    'Can I get a refund?':
      'We offer a 30-day money-back guarantee for all new subscriptions. If you are not satisfied, please contact our support team within 30 days of your purchase to request a refund.'
  };


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
          'Help Center',
          style: TextStyle(color: kDarkTextColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        children: [
          // --- Header Section ---
          const Text(
            'How can we help you?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kDarkTextColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // --- Search Field ---
          _buildSearchField(),
          const SizedBox(height: 30),

          // --- FAQ Sections ---
          _buildFaqCategory(title: 'Account & Profile', faqs: _accountFaqs),
          const SizedBox(height: 20),
          _buildFaqCategory(title: 'Billing & Subscriptions', faqs: _billingFaqs),
          const SizedBox(height: 30),

          // --- Contact Support Card ---
          _ContactSupportCard(onTap: () {
            // Add logic to navigate to a contact form, open an email client, or a chat window
          }),
        ],
      ),
    );
  }

  /// Builds the styled search text field.
  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search for articles...',
        hintStyle: const TextStyle(color: kSecondaryTextColor),
        prefixIcon: const Icon(Icons.search, color: kSecondaryTextColor),
        filled: true,
        fillColor: kCardBackgroundColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  /// Builds a card containing a category of FAQs.
  Widget _buildFaqCategory({required String title, required Map<String, String> faqs}) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kDarkTextColor,
              ),
            ),
            const SizedBox(height: 10),
            // Create an expandable tile for each FAQ in the map
            ...faqs.entries.map((entry) {
              return _FaqItem(question: entry.key, answer: entry.value);
            }).toList(),
          ],
        ),
      ),
    );
  }
}

/// A custom widget for a single, expandable FAQ item.
class _FaqItem extends StatelessWidget {
  const _FaqItem({
    required this.question,
    required this.answer,
  });

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(fontWeight: FontWeight.w500, color: kDarkTextColor),
      ),
      iconColor: kPrimaryColor,
      collapsedIconColor: kSecondaryTextColor,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            answer,
            style: const TextStyle(color: kSecondaryTextColor, height: 1.5),
          ),
        ),
      ],
    );
  }
}

/// A card that prompts the user to contact support.
class _ContactSupportCard extends StatelessWidget {
  const _ContactSupportCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Icon(Icons.support_agent, color: kPrimaryColor, size: 40),
            const SizedBox(height: 10),
            const Text(
              'Still need help?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kDarkTextColor),
            ),
            const SizedBox(height: 5),
            const Text(
              'Our support team is here to assist you.',
              textAlign: TextAlign.center,
              style: TextStyle(color: kSecondaryTextColor),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'Contact Support',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}