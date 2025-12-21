import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grade_learn/models/Intenship.dart';

class InternshipDetailsPage extends StatelessWidget {
  final Internship internship; // Direct link to the model
  const InternshipDetailsPage({super.key, required this.internship});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFF9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFF9),
        elevation: 0,
        leadingWidth: 120,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Row(
            children: [
              SizedBox(width: 16),
              Icon(Icons.arrow_back, color: Colors.black, size: 28),
              SizedBox(width: 8),
              Text(
                "BACK",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- HEADER CARD ----------
            _CustomCard(
              color: internship.cardColor,
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: Colors.black,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(
                        internship.iconData,
                        size: 40,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    internship.role.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    internship.company.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ---------- STATS ----------
            Row(
              children: [
                _buildStatItem(Icons.payments, internship.stipend, 'STIPEND'),
                const SizedBox(width: 12),
                _buildStatItem(Icons.timer, internship.duration, 'MONTHS'),
                const SizedBox(width: 12),
                _buildStatItem(FontAwesomeIcons.briefcase, internship.type, 'LEVEL'),
              ],
            ),

            const SizedBox(height: 20),

            // ---------- DESCRIPTION ----------
            _CustomCard(
              color: Colors.white,
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(title: "ROLE DESCRIPTION"),
                  Text(
                    "JOIN THE TEAM AT ${internship.company} AS A  ${internship.role}. "
                    "THIS ${internship.type} POSITION IS FOR ${internship.duration}.",
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ---------- SKILLS REQUIRED ----------
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: const _SectionHeader(title: 'SKILL YOU WILL REQUIRED'),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  "REACT",
                  "NODE JS",
                  "AZURE",
                ].map((skill) => _skillBadge(skill)).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // ---------- KEY RESPONSIBILITIES ----------
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: const _SectionHeader(title: "KEY RESPONSIBILITIES"),
            ),
            const SizedBox(height: 8),
            _CustomCard(
              color: const Color(0xFFB5C0FF),
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _includeRow(
                    FontAwesomeIcons.briefcase,
                    "DEVELOP FULL-STACK WEB APPLICATIONS",
                  ),
                  _includeRow(
                    FontAwesomeIcons.briefcase,
                    "BUILD RESTFUL APIS USING NODE.JS",
                  ),
                  _includeRow(
                    FontAwesomeIcons.briefcase,
                    "CREATE RESPONSIVE UIS WITH REACT",
                  ),
                  _includeRow(
                    FontAwesomeIcons.briefcase,
                    "DEPLOY APPLICATIONS TO AZURE",
                  ),
                  _includeRow(
                    FontAwesomeIcons.briefcase,
                    "WRITE UNIT AND INTEGRATION TESTS",
                  ),
                  _includeRow(
                    FontAwesomeIcons.briefcase,
                    "PARTICIPATE IN AGILE DEVELOPMENT",
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // ---------- QUALIFICATIONS ----------
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: const _SectionHeader(title: "QUALIFICATIONS"),
            ),
            const SizedBox(height: 8),
            _CustomCard(
              color: const Color(0xFFFDE798),
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _includeRow(
                    Icons.mark_email_read,
                    "PURSUING DEGREE IN COMPUTER SCIENCE OR RELATED FIELD",
                  ),
                  _includeRow(
                    Icons.mark_email_read,
                    "EXPERIENCE WITH REACT AND NODE.JS",
                  ),
                  _includeRow(Icons.mark_email_read, "KNOWLEDGE OF REST APIS"),
                  _includeRow(
                    Icons.mark_email_read,
                    "FAMILIARITY WITH CLOUD PLATFORMS",
                  ),
                  _includeRow(
                    Icons.mark_email_read,
                    "GIT VERSION CONTROL EXPERIENCE",
                  ),
                  _includeRow(
                    Icons.mark_email_read,
                    "TEAM PLAYER WITH GOOD COMMUNICATION",
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // ---------- BENIFITS OR PERKS ----------
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: const _SectionHeader(title: "BENEFITS & PERKS"),
            ),
            const SizedBox(height: 12),
            ...[
              'HYBRID WORK ENVIRONMENT',
              'PERSONAL DEVELOPMENT BUDGET',
              'HEALTH & WELLNESS PROGRAMS',
              'EMPLOY DISCOUNT PROGRAMS',
              'COLABORATIVE WORK EVIRONMENT',
              'CAREER GROWTH OPPORTUNITIES',
            ].map(
              (req) => Padding(
                padding: const EdgeInsets.only(bottom: 12, left: 20),
                child: Row(
                  children: [
                    const Icon(Icons.badge_outlined, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      req,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- ABOUT COMPANY ---
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: const _SectionHeader(title: "ABOUT YOUR COMPANY"),
            ),
            SizedBox(height: 12),
            _CustomCard(
              color: Colors.white,
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.black,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "MICROSOFT",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            "BY BILL GATES",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 12,
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  const Text(
                    "MICROSOFT HAS BEEN A LEADER IN TECHNOLOGY FOR DECADES, INNOVATING AND EMPOWERING PEOPLE WORLDWIDE.",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            // ---------- REQUIREMENTS ----------
            Padding(
              padding: const EdgeInsets.only(left:10),
              child: const _SectionHeader(title: 'APPLICATION PROCESS & REQUIREMENTS')),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _numItem(
                  1,
                  'APPLICATION REVIEW',
                  '1-2 WEEK.',
                ),
                _numItem(
                  2,
                  'ONLINE ASSESSMENT',
                  '3-5 DAYS',
                ),
                _numItem(
                  3,
                  'TECHNICAL INTERVIEW',
                  '1 WEEK',
                ),
                _numItem(
                  4,
                  'FINAL INTERVIEW',
                  '1 WEEK',
                ),
                  _numItem(
                  5,
                  'OFFER EXTENSION',
                  '1-2 WEEK.'),
              ],
            ),
            const SizedBox(height: 20),
            // ---------- CONNECT ----------
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: const _SectionHeader(title: "QUESTIONS? CONNECT WITH US"),
            ),
            const SizedBox(height: 8),
            _CustomCard(
              color: const Color(0xFFB5C0FF),
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _includeRow(
                    Icons.mail_outline,
                    "donotreply@microsoft.com",
                  ),
                  _includeRow(
                    Icons.web,
                    "www.microsoft.com",
                  ),
                  _includeRow(FontAwesomeIcons.linkedin, "Microsoft "),
                ],
              ),
            ),
            SizedBox(height: 20),
            // ---------- APPLY BUTTON (END OF CARD) ----------
            GestureDetector(
              onTap: () {
                // apply / enroll logic
              },
              child: Container(
                width: double.infinity,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                alignment: Alignment.center,
                child: const Text(
                  "APPLY FOR INTERNSHIP",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ---------- HELPERS ----------
  Widget _buildStatItem(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: const [
            BoxShadow(color: Colors.black, offset: Offset(1, 1)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: Colors.black),
            const SizedBox(height: 6),
            Text(
              value.split(' ').first.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- REUSABLE COMPONENTS ----------

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _CustomCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final EdgeInsets padding;

  const _CustomCard({
    required this.child,
    required this.color,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2, 2))],
      ),
      child: child,
    );
  }
}

// ---------- SKILL BADGE COMPONENT ----------
Widget _skillBadge(String label) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.black, width: 2),
      boxShadow: const [
        BoxShadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 0),
      ],
    ),
    child: Text(
      label,
      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
    ),
  );
}

//---------- KEY RESPONSIBILITIES ROW COMPONENT ----------
Widget _includeRow(IconData icon, String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22),
        const SizedBox(width: 12),

        // 🔥 OVERFLOW FIX
        Expanded(
          child: Text(
            text,
            softWrap: true,
            maxLines: 2, // increase if needed
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              height: 1.4,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _numItem(int n, String title, String desc) => Padding(
  padding: const EdgeInsets.only(bottom: 12),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left:10),
        child: CircleAvatar(
          radius: 18,
          backgroundColor: Colors.black.withOpacity(0.1),
          child: Text(
            '$n.',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.black),
          ),
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 2),
            Text(
              desc,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      ),
    ],
  ),
);
