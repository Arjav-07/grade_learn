import 'package:flutter/material.dart';

// --- Brutalist Design Constants ---
const Color kBrutalistBg = Color(0xFFFFFFF9);
const Color kBrutalistYellow = Color(0xFFFDE798);
const Color kBrutalistBlue = Color(0xFFB5D8FF);
const Color kBrutalistPurple = Color(0xFF7A64D8);
const Color kDarkTextColor = Color(0xFF282C35);

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _headlineController;
  late final TextEditingController _skillsController;
  late final TextEditingController _goalsController;

  IconData _selectedAvatar = Icons.person_outline;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'ALEX DOE');
    _headlineController = TextEditingController(text: 'ASPIRING FLUTTER DEVELOPER');
    _skillsController = TextEditingController(text: 'FLUTTER, DART, FIREBASE, UI/UX');
    _goalsController = TextEditingController(text: 'TO BUILD IMPACTFUL APPLICATIONS');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _headlineController.dispose();
    _skillsController.dispose();
    _goalsController.dispose();
    super.dispose();
  }

  void _showAvatarSelectionDialog() {
    final List<IconData> avatars = [
      Icons.person, Icons.face, Icons.account_circle, Icons.emoji_emotions,
      Icons.pets, Icons.anchor, Icons.rocket_launch, Icons.star,
      Icons.favorite, Icons.lightbulb, Icons.school, Icons.sports_esports,
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.black, width: 2.5),
          ),
          backgroundColor: kBrutalistBg,
          title: const Text('CHOOSE AVATAR', style: TextStyle(fontWeight: FontWeight.w900)),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: avatars.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final avatar = avatars[index];
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedAvatar = avatar);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: _selectedAvatar == avatar ? kBrutalistYellow : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: Icon(avatar, color: Colors.black),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
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
            // --- BACK BUTTON ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back, size: 28, color: Colors.black),
                    SizedBox(width: 8),
                    Text("BACK", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text('EDIT PROFILE ✏️', style: TextStyle(fontSize: 38, fontWeight: FontWeight.w900, height: 1.1)),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24.0),
                children: [
                  _ProfileAvatar(
                    selectedAvatar: _selectedAvatar,
                    onTap: _showAvatarSelectionDialog,
                  ),
                  const SizedBox(height: 40),
                  _buildBrutalistField(_nameController, 'FULL NAME', Icons.person_outline),
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
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PROFILE UPDATED!', style: TextStyle(fontWeight: FontWeight.w900)), backgroundColor: Colors.black),
        );
      },
      child: Container(
        height: 65,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: kBrutalistPurple, offset: Offset(4, 4))],
        ),
        child: const Center(
          child: Text(
            "SAVE CHANGES",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1.2),
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
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 3),
                boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: kBrutalistBlue,
                child: Icon(selectedAvatar, size: 60, color: Colors.black),
              ),
            ),
            Positioned(
              bottom: 5,
              right: 5,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: kBrutalistYellow,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: const Icon(Icons.edit, color: Colors.black, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}