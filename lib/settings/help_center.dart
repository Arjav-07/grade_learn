import 'package:flutter/material.dart';

// --- Brutalist Design Constants ---
const Color kBrutalistBg = Color(0xFFFFFFF9);
const Color kBrutalistYellow = Color(0xFFFDE798);
const Color kBrutalistBlue = Color(0xFFB5D8FF);
const Color kBrutalistPurple = Color(0xFF7A64D8);
const Color kDarkTextColor = Color(0xFF282C35);

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  final Map<String, String> _accountFaqs = {
    'HOW DO I CHANGE MY USERNAME?': 
      'YOU CAN UPDATE YOUR PERSONAL INFORMATION BY NAVIGATING TO THE SETTINGS PAGE AND SELECTING "EDIT PROFILE".',
    'HOW DO I RESET MY PASSWORD?':
      'ON THE LOGIN SCREEN, TAP THE "FORGOT PASSWORD?" LINK TO RECEIVE EMAIL INSTRUCTIONS.',
    'HOW DO I DELETE MY ACCOUNT?':
      'PLEASE CONTACT OUR SUPPORT TEAM THROUGH THE BUTTON ON THIS PAGE FOR PERMANENT DELETION.'
  };

  final Map<String, String> _billingFaqs = {
    'WHAT PAYMENT METHODS DO YOU ACCEPT?':
      'WE ACCEPT ALL MAJOR CREDIT AND DEBIT CARDS, INCLUDING VISA, MASTERCARD, AND AMERICAN EXPRESS.',
    'HOW DO I CANCEL MY SUBSCRIPTION?':
      'MANAGE YOUR PLAN BY GOING TO SETTINGS > PAYMENT METHODS TO FIND THE CANCELLATION OPTION.',
    'CAN I GET A REFUND?':
      'WE OFFER A 30-DAY MONEY-BACK GUARANTEE. CONTACT SUPPORT WITHIN 30 DAYS OF PURCHASE.'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBrutalistBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            
            // --- BACK BUTTON ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.arrow_back, size: 28, color: Colors.black),
                    const SizedBox(width: 8),
                    const Text(
                      "BACK",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'HELP CENTER 🆘',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  height: 1.1,
                ),
              ),
            ),

            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                children: [
                  const Text(
                    'HOW CAN WE HELP YOU?',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- SEARCH FIELD ---
                  _buildBrutalistSearchField(),
                  const SizedBox(height: 30),

                  // --- FAQ SECTIONS ---
                  _buildFaqCategory(title: 'ACCOUNT & PROFILE', faqs: _accountFaqs, color: kBrutalistBlue),
                  const SizedBox(height: 20),
                  _buildFaqCategory(title: 'BILLING & SUBSCRIPTIONS', faqs: _billingFaqs, color: kBrutalistYellow),
                  const SizedBox(height: 30),

                  // --- CONTACT SUPPORT CARD ---
                  _ContactSupportCard(onTap: () {}),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrutalistSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black, width: 2.5),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(fontWeight: FontWeight.bold),
        decoration: const InputDecoration(
          hintText: 'SEARCH FOR ARTICLES...',
          hintStyle: TextStyle(color: Colors.black38, fontWeight: FontWeight.bold),
          prefixIcon: Icon(Icons.search, color: Colors.black),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildFaqCategory({required String title, required Map<String, String> faqs, required Color color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black, width: 2.5),
            boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
          ),
          child: Column(
            children: faqs.entries.map((entry) {
              return _FaqItem(question: entry.key, answer: entry.value, accentColor: color);
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _FaqItem extends StatelessWidget {
  const _FaqItem({required this.question, required this.answer, required this.accentColor});
  final String question;
  final String answer;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.black, fontSize: 14),
        ),
        iconColor: Colors.black,
        collapsedIconColor: Colors.black,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: const TextStyle(color: Colors.black87, height: 1.4, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactSupportCard extends StatelessWidget {
  const _ContactSupportCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black, width: 2.5),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kBrutalistBlue,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 1.5),
            ),
            child: const Icon(Icons.support_agent, color: Colors.black, size: 40),
          ),
          const SizedBox(height: 16),
          const Text(
            'STILL NEED HELP?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black),
          ),
          const SizedBox(height: 8),
          const Text(
            'OUR SUPPORT TEAM IS HERE TO ASSIST YOU.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [BoxShadow(color: kBrutalistPurple, offset: Offset(4, 4))],
              ),
              alignment: Alignment.center,
              child: const Text(
                'CONTACT SUPPORT',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1.1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}