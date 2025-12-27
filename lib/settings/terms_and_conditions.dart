import 'package:flutter/material.dart';

// --- Brutalist Design Constants ---
const Color kBrutalistBg = Color(0xFFFFFFF9);
const Color kBrutalistYellow = Color(0xFFFDE798);
const Color kBrutalistBlue = Color(0xFFB5D8FF);
const Color kBrutalistPurple = Color(0xFF7A64D8);
const Color kDarkTextColor = Color(0xFF282C35);

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

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
                'TERMS & CONDITIONS',
                style: TextStyle(
                  fontSize: 34,
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
                    'EFFECTIVE DATE: DECEMBER 27, 2025',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildBrutalistContainer(
                    child: const Text(
                      'PLEASE READ THESE TERMS AND CONDITIONS ("TERMS") CAREFULLY BEFORE USING THE GRADE LEARN MOBILE APPLICATION OPERATED BY GRADE LEARN INC.',
                      style: TextStyle(fontWeight: FontWeight.bold, height: 1.4, color: Colors.black87),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- SECTION 1 ---
                  _buildSectionHeader('1. AGREEMENT TO TERMS'),
                  _buildBrutalistContainer(
                    color: kBrutalistBlue,
                    child: _buildBrutalistParagraph(
                      'BY ACCESSING OR USING OUR SERVICE, YOU AGREE TO BE BOUND BY THESE TERMS. IF YOU DISAGREE WITH ANY PART, YOU MAY NOT ACCESS THE SERVICE.'
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- SECTION 2 ---
                  _buildSectionHeader('2. ACCOUNTS'),
                  _buildBrutalistContainer(
                    color: kBrutalistYellow,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBrutalistParagraph('YOU MUST PROVIDE ACCURATE AND COMPLETE INFORMATION AT ALL TIMES.'),
                        const SizedBox(height: 12),
                        _buildBrutalistParagraph('YOU ARE RESPONSIBLE FOR SAFEGUARDING YOUR PASSWORD AND FOR ANY ACTIVITIES UNDER YOUR ACCOUNT.'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- SECTION 3 ---
                  _buildSectionHeader('3. PROHIBITED USES'),
                  _buildBrutalistContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBrutalistListItem('UNLAWFUL, ILLEGAL, OR HARMFUL ACTIVITIES.'),
                        _buildBrutalistListItem('DISCRIMINATION BASED ON RACE, RELIGION, OR DISABILITY.'),
                        _buildBrutalistListItem('VIOLATING INTELLECTUAL PROPERTY RIGHTS.'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- SECTION 4 ---
                  _buildSectionHeader('4. GOVERNING LAW'),
                  _buildBrutalistContainer(
                    child: _buildBrutalistParagraph(
                      'THESE TERMS SHALL BE GOVERNED AND CONSTRUED IN ACCORDANCE WITH THE LAWS OF INDIA.'
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- CONTACT ---
                  _buildSectionHeader('5. CONTACT US'),
                  _buildBrutalistContainer(
                    color: Colors.black,
                    child: const Text(
                      'ARJAVBHISARA07@GMAIL.COM',
                      style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.2),
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

  Widget _buildBrutalistContainer({required Widget child, Color color = Colors.white}) {
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