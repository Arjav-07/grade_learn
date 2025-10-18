import 'package:flutter/material.dart';
import 'package:grade_learn/auth/onboarding_page.dart';
import 'package:grade_learn/settings/change_password.dart';
import 'package:grade_learn/settings/edit_profile.dart';
import 'package:grade_learn/settings/help_center.dart';
import 'package:grade_learn/settings/privac';
import 'package:grade_learn/settings/privacy_policy.dart';

// --- Constants for consistent design ---
const Color kPrimaryColor = Color(0xFF7A64D8);
const Color kIconColor = Color(0xFF424242);

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // State variables for the notification toggles
  bool _pushNotifications = true;
  bool _emailNotifications = false;

  @override
  Widget build(BuildContext context) {
    // --- UI Constants for consistent theming ---
    const Color primaryBackgroundColor = Color(0xFFFFD9C0);
    const Color cardBackgroundColor = Colors.white;
    const BorderRadius topBorderRadius = BorderRadius.only(
      topLeft: Radius.circular(32),
      topRight: Radius.circular(32),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF9093E1).withOpacity(0.9),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Text(
              'Settings',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                height: 1.2,
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: cardBackgroundColor,
                borderRadius: topBorderRadius,
              ),
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                children: [
                  // --- Account Card ---
                  _SettingsGroupCard(
                    title: 'Account',
                    children: [
                      _SettingsTile(icon: Icons.person_outline, title: 'Edit Profile', onTap: () {
    // Example: Navigate to EditProfilePage with dummy initial data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditProfilePage(
        ),
      ),
    );
  },
                      ),
                      _SettingsTile(icon: Icons.lock_outline, title: 'Change Password', onTap: () {
    // Example: Navigate to EditProfilePage with dummy initial data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChangePasswordPage(
        ),
      ),
    );
  },),
                      _SettingsTile(icon: Icons.credit_card_outlined, title: 'Payment Methods', onTap: () {},),
                    ],
                  ),

                  // --- Notifications Card ---
                  _SettingsGroupCard(
                    title: 'Notifications',
                    children: [
                      _SettingsSwitchTile(
                        icon: Icons.notifications_active_outlined,
                        title: 'Push Notifications',
                        value: _pushNotifications,
                        onChanged: (value) => setState(() => _pushNotifications = value),
                      ),
                      _SettingsSwitchTile(
                        icon: Icons.email_outlined,
                        title: 'Email Notifications',
                        value: _emailNotifications,
                        onChanged: (value) => setState(() => _emailNotifications = value),
                      ),
                    ],
                  ),

                  // --- Support & About Card ---
                  _SettingsGroupCard(
                    title: 'Support & About',
                    children: [
                      _SettingsTile(icon: Icons.help_outline, title: 'Help Center', onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HelpCenterPage(),),);
                          }),
                      _SettingsTile(icon: Icons.privacy_tip_outlined, title: 'Privacy Policy', onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PrivacyPolicyPage(),),);
                          }),
                      _SettingsTile(icon: Icons.description_outlined, title: 'Terms of Service', onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const TermsAndConditionsPage(),),);
                          }),
                    ],
                  ),

                  // --- Logout Button Card ---
                  const SizedBox(height: 16),
                  _LogoutButtonCard(onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const OnboardingPage(),),);
                          }),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Reusable Helper Widgets for Clean Code ---

/// A card that groups related settings.
class _SettingsGroupCard extends StatelessWidget {
  const _SettingsGroupCard({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24.0, bottom: 8.0),
            child: Text(
              title.toUpperCase(),
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

/// A standard tappable tile for navigation.
class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
      onTap: onTap,
      leading: Icon(icon, color: kIconColor),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
    );
  }
}

/// A tile with a toggle switch.
class _SettingsSwitchTile extends StatelessWidget {
  const _SettingsSwitchTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
      leading: Icon(icon, color: kIconColor),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: kPrimaryColor,
      ),
      onTap: () => onChanged(!value),
    );
  }
}

// A dedicated, styled logout button in card form.
class _LogoutButtonCard extends StatelessWidget {
  const _LogoutButtonCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      child: Material(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: const Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.logout, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}