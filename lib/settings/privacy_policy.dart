import 'package:flutter/material.dart';

// --- Brutalist Design Constants ---
const Color kBrutalistBg = Color(0xFFFFFFF9);
const Color kBrutalistYellow = Color(0xFFFDE798);
const Color kBrutalistBlue = Color(0xFFB5D8FF);
const Color kBrutalistPurple = Color(0xFF7A64D8);
const Color kDarkTextColor = Color(0xFF282C35);

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
                'PRIVACY POLICY',
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
                    'LAST UPDATED: OCTOBER 18, 2025',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildPolicyContainer(
                    child: const Text(
                      'WELCOME TO GRADE LEARN ("WE", "US", OR "OUR"). WE ARE COMMITTED TO PROTECTING YOUR PERSONAL INFORMATION AND YOUR RIGHT TO PRIVACY. IF YOU HAVE ANY QUESTIONS, PLEASE CONTACT US.',
                      style: TextStyle(fontWeight: FontWeight.bold, height: 1.4, color: Colors.black87),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- SECTION 1 ---
                  _buildSectionHeader('1. INFORMATION WE COLLECT'),
                  _buildPolicyContainer(
                    color: kBrutalistBlue,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBrutalistParagraph('WE COLLECT PERSONAL INFORMATION THAT YOU VOLUNTARILY PROVIDE TO US WHEN YOU REGISTER ON THE APP.'),
                        const SizedBox(height: 12),
                        _buildBrutalistListItem('PERSONAL DATA: NAMES; EMAIL ADDRESSES; USERNAMES; PASSWORDS.'),
                        _buildBrutalistListItem('USAGE DATA: DEVICE IP, TYPE, OS VERSION, AND DATE/TIME OF USE.'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- SECTION 2 ---
                  _buildSectionHeader('2. HOW WE USE DATA'),
                  _buildPolicyContainer(
                    color: kBrutalistYellow,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBrutalistListItem('TO FACILITATE ACCOUNT CREATION AND LOGON.'),
                        _buildBrutalistListItem('TO MANAGE USER ACCOUNTS AND KEEP THEM IN WORKING ORDER.'),
                        _buildBrutalistListItem('TO SEND ADMINISTRATIVE INFORMATION TO YOU.'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- SECTION 3 ---
                  _buildSectionHeader('3. DATA SECURITY'),
                  _buildPolicyContainer(
                    child: _buildBrutalistParagraph(
                      'WE HAVE IMPLEMENTED APPROPRIATE TECHNICAL SECURITY MEASURES. HOWEVER, NO ELECTRONIC TRANSMISSION CAN BE GUARANTEED 100% SECURE.'
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- CONTACT US ---
                  _buildSectionHeader('4. CONTACT US'),
                  _buildPolicyContainer(
                    color: Colors.black,
                    textColor: Colors.white,
                    child: const Text(
                      'ARJAVBHISARA07@GMAIL.COM\nSKILL WAVES.\nINDIA',
                      style: TextStyle(fontWeight: FontWeight.w900, height: 1.5, color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- BRUTALIST HELPERS ---

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black),
      ),
    );
  }

  Widget _buildPolicyContainer({required Widget child, Color color = Colors.white, Color textColor = Colors.black}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 2.5),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
      ),
      child: child,
    );
  }

  Widget _buildBrutalistParagraph(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, height: 1.4, color: Colors.black87),
    );
  }

  Widget _buildBrutalistListItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}