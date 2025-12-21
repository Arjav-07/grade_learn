import 'package:flutter/material.dart';
import 'package:grade_learn/auth/onboarding_page.dart';
import 'package:grade_learn/settings/change_password.dart';
import 'package:grade_learn/settings/edit_profile.dart';
import 'package:grade_learn/settings/help_center.dart';
import 'package:grade_learn/settings/privacy_policy.dart';
import 'package:grade_learn/settings/terms_and_conditions.dart';

// --- Brutalist Design Constants ---
const Color kBrutalistBg = Color(0xFFFFFFF9);
const Color kBrutalistYellow = Color(0xFFFDE798);
const Color kBrutalistBlue = Color(0xFFB5D8FF);
const Color kBrutalistPurple = Color(0xFF7A64D8);
const Color kDarkTextColor = Color(0xFF282C35);

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;

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
                'SETTINGS ⚙️',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  height: 1.1,
                ),
              ),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 40),
                children: [
                  // --- ACCOUNT SECTION ---
                  _SettingsGroupCard(
                    title: 'ACCOUNT',
                    children: [
                      _SettingsTile(
                        icon: Icons.person_outline, 
                        title: 'EDIT PROFILE', 
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfilePage())),
                      ),
                      _SettingsTile(
                        icon: Icons.lock_outline, 
                        title: 'CHANGE PASSWORD', 
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePasswordPage())),
                      ),
                      _SettingsTile(icon: Icons.credit_card_outlined, title: 'PAYMENT METHODS', onTap: () {}),
                    ],
                  ),

                  // --- NOTIFICATIONS SECTION ---
                  _SettingsGroupCard(
                    title: 'NOTIFICATIONS',
                    children: [
                      _SettingsSwitchTile(
                        icon: Icons.notifications_active_outlined,
                        title: 'PUSH NOTIFICATIONS',
                        value: _pushNotifications,
                        onChanged: (value) => setState(() => _pushNotifications = value),
                      ),
                      _SettingsSwitchTile(
                        icon: Icons.email_outlined,
                        title: 'EMAIL NOTIFICATIONS',
                        value: _emailNotifications,
                        onChanged: (value) => setState(() => _emailNotifications = value),
                      ),
                    ],
                  ),

                  // --- SUPPORT SECTION ---
                  _SettingsGroupCard(
                    title: 'SUPPORT & ABOUT',
                    children: [
                      _SettingsTile(
                        icon: Icons.help_outline, 
                        title: 'HELP CENTER', 
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpCenterPage())),
                      ),
                      _SettingsTile(
                        icon: Icons.privacy_tip_outlined, 
                        title: 'PRIVACY POLICY', 
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPolicyPage())),
                      ),
                      _SettingsTile(
                        icon: Icons.description_outlined, 
                        title: 'TERMS OF SERVICE', 
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsAndConditionsPage())),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // --- LOGOUT BUTTON ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _LogoutButton(onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context, 
                        MaterialPageRoute(builder: (_) => const OnboardingPage()),
                        (route) => false
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- BRUTALIST HELPERS ---

class _SettingsGroupCard extends StatelessWidget {
  const _SettingsGroupCard({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 24, 12),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Colors.black54),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.black, width: 2.5),
            boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({required this.icon, required this.title, required this.onTap});
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: kBrutalistBlue,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 1.5),
        ),
        child: Icon(icon, color: Colors.black, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black),
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  const _SettingsSwitchTile({required this.icon, required this.title, required this.value, required this.onChanged});
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: kBrutalistYellow,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 1.5),
        ),
        child: Icon(icon, color: Colors.black, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.black,
        activeTrackColor: kBrutalistPurple.withOpacity(0.5),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 65,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: const [BoxShadow(color: kBrutalistPurple, offset: Offset(4, 4))],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: Colors.white),
            SizedBox(width: 12),
            Text(
              "LOGOUT ACCOUNT",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1.2),
            ),
          ],
        ),
      ),
    );
  }
}