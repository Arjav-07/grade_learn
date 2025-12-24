import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// --- Brutalist Design Constants ---
const Color kBrutalistBg = Color(0xFFFFFFF9);
const Color kBrutalistYellow = Color(0xFFFDE798);
const Color kBrutalistBlue = Color(0xFFB5D8FF);
const Color kBrutalistPurple = Color(0xFF7A64D8);

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  // Controller for 'username' only
  late final TextEditingController _usernameController;
  late final TextEditingController _headlineController;
  late final TextEditingController _skillsController;
  late final TextEditingController _goalsController;

  bool _isLoading = false;
  IconData _selectedAvatar = Icons.person_outline;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _headlineController = TextEditingController();
    _skillsController = TextEditingController();
    _goalsController = TextEditingController();

    _loadUserData();
  }

  // --- FETCH DATA FROM FIRESTORE ---
  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists && mounted) {
        final data = doc.data()!;
        setState(() {
          // Strictly fetching 'username'
          _usernameController.text = data['username'] ?? '';
          _headlineController.text = data['headline'] ?? '';
          _skillsController.text = data['skills'] ?? '';
          _goalsController.text = data['goals'] ?? '';
          
          // Reconstruct icon from stored code point
          if (data['avatarCodePoint'] != null) {
            _selectedAvatar = IconData(
              data['avatarCodePoint'], 
              fontFamily: 'MaterialIcons'
            );
          }
        });
      }
    }
  }

  // --- SAVE DATA TO FIRESTORE ---
  Future<void> _updateProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);

    try {
      final String newUsername = _usernameController.text.trim();

      // 1. Update Firebase Auth DisplayName
      await user.updateDisplayName(newUsername);

      // 2. Update Firestore Document (Strictly 'username')
      await _firestore.collection('users').doc(user.uid).set({
        'username': newUsername, 
        'headline': _headlineController.text.trim(),
        'skills': _skillsController.text.trim(),
        'goals': _goalsController.text.trim(),
        'avatarCodePoint': _selectedAvatar.codePoint, 
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('USERNAME UPDATED!', style: TextStyle(fontWeight: FontWeight.w900)),
            backgroundColor: Colors.black,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBrutalistBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildHeaderBtn(context),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text('EDIT PROFILE ✏️', style: TextStyle(fontSize: 38, fontWeight: FontWeight.w900, height: 1.1)),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24.0),
                children: [
                  _ProfileAvatar(selectedAvatar: _selectedAvatar, onTap: _showAvatarSelectionDialog),
                  const SizedBox(height: 40),
                  // Updated to use _usernameController
                  _buildBrutalistField(_usernameController, 'USERNAME', Icons.alternate_email),
                  const SizedBox(height: 20),
                  _buildBrutalistField(_headlineController, 'HEADLINE', Icons.lightbulb_outline),
                  const SizedBox(height: 20),
                  _buildBrutalistField(_skillsController, 'YOUR SKILLS', Icons.code, maxLines: 2),
                  const SizedBox(height: 20),
                  _buildBrutalistField(_goalsController, 'CAREER GOALS', Icons.flag_outlined, maxLines: 2),
                  const SizedBox(height: 40),
                  _buildSaveButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widgets
  Widget _buildHeaderBtn(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: const Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.arrow_back, size: 28, color: Colors.black),
        SizedBox(width: 8),
        Text("BACK", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
      ]),
    ),
  );

  Widget _buildBrutalistField(TextEditingController controller, String label, IconData icon, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.black, width: 2.5),
            boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: const TextStyle(fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.black),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _updateProfile,
      child: Container(
        height: 65,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: kBrutalistPurple, offset: Offset(4, 4))],
        ),
        child: Center(
          child: _isLoading 
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("SAVE CHANGES", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
        ),
      ),
    );
  }

  void _showAvatarSelectionDialog() {
    final List<IconData> avatars = [
      Icons.person, Icons.face, Icons.account_circle, Icons.emoji_emotions,
      Icons.pets, Icons.anchor, Icons.rocket_launch, Icons.star,
      Icons.favorite, Icons.lightbulb, Icons.school, Icons.sports_esports,
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Colors.black, width: 2.5)),
        backgroundColor: kBrutalistBg,
        title: const Text('CHOOSE AVATAR', style: TextStyle(fontWeight: FontWeight.w900)),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: avatars.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 10, mainAxisSpacing: 10),
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                setState(() => _selectedAvatar = avatars[index]);
                Navigator.of(context).pop();
              },
              child: Container(
                decoration: BoxDecoration(color: _selectedAvatar == avatars[index] ? kBrutalistYellow : Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.black, width: 2)),
                child: Icon(avatars[index], color: Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final IconData selectedAvatar;
  final VoidCallback onTap;
  const _ProfileAvatar({required this.selectedAvatar, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black, width: 3), boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))]),
              child: CircleAvatar(radius: 60, backgroundColor: kBrutalistBlue, child: Icon(selectedAvatar, size: 60, color: Colors.black)),
            ),
            Positioned(bottom: 5, right: 5, child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: kBrutalistYellow, shape: BoxShape.circle, border: Border.all(color: Colors.black, width: 2)), child: const Icon(Icons.edit, color: Colors.black, size: 20))),
          ],
        ),
      ),
    );
  }
}