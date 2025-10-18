import 'package:flutter/material.dart';

// Theme constants from your app
const Color kScaffoldBackground = Color(0xFFF8F9FA);
const Color kPrimaryTextColor = Color(0xFF343A40);
const Color kSecondaryTextColor = Color(0xFF6C757D);
const Color kAccentColor = Colors.black;
const Color kBotBubbleColor = Color(0xFFE9ECEF);

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _headlineController;
  late final TextEditingController _skillsController;
  late final TextEditingController _goalsController;

  // ✨ NEW: State variable to hold the currently selected avatar icon.
  IconData _selectedAvatar = Icons.person_outline;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Alex Doe');
    _headlineController = TextEditingController(text: 'Aspiring Flutter Developer');
    _skillsController = TextEditingController(text: 'Flutter, Dart, Firebase, UI/UX Design');
    _goalsController = TextEditingController(text: 'To build beautiful and impactful mobile applications.');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _headlineController.dispose();
    _skillsController.dispose();
    _goalsController.dispose();
    super.dispose();
  }
  
  void _saveProfile() {
    print('Saving Profile...');
    print('Selected Avatar: ${_selectedAvatar.codePoint}'); // Save the chosen avatar
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile Updated Successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // ✨ NEW: Function to show the avatar selection popup.
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
          title: const Text('Choose a Profile Picture'),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: avatars.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                final avatar = avatars[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAvatar = avatar;
                    });
                    Navigator.of(context).pop(); // Close the dialog on selection
                  },
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: _selectedAvatar == avatar ? kAccentColor : kBotBubbleColor,
                    child: Icon(
                      avatar,
                      size: 30,
                      color: _selectedAvatar == avatar ? Colors.white : kSecondaryTextColor,
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: kAccentColor)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackground,
      appBar: AppBar(
        backgroundColor: kScaffoldBackground,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kPrimaryTextColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: kPrimaryTextColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        children: [
          // ✨ MODIFIED: Pass the selected avatar and the tap handler to the widget.
          _ProfileAvatar(
            selectedAvatar: _selectedAvatar,
            onTap: _showAvatarSelectionDialog,
          ),
          const SizedBox(height: 30),
          _buildTextField(
            controller: _nameController,
            labelText: 'Full Name',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _headlineController,
            labelText: 'Headline',
            icon: Icons.lightbulb_outline,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _skillsController,
            labelText: 'Your Skills',
            icon: Icons.code,
            maxLines: 3,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _goalsController,
            labelText: 'Career Goals',
            icon: Icons.flag_outlined,
            maxLines: 3,
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: kAccentColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: kSecondaryTextColor),
        prefixIcon: Icon(icon, color: kSecondaryTextColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kBotBubbleColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kBotBubbleColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kAccentColor, width: 2.0),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}

// ✨ MODIFIED: This widget is now more dynamic.
class _ProfileAvatar extends StatelessWidget {
  final IconData selectedAvatar;
  final VoidCallback onTap;

  const _ProfileAvatar({
    Key? key,
    required this.selectedAvatar,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector( // ✨ Wrap the entire avatar to make it tappable.
        onTap: onTap,
        child: Stack(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: kBotBubbleColor,
              // ✨ Display the icon passed from the parent widget.
              child: Icon(selectedAvatar, size: 60, color: kSecondaryTextColor),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: kAccentColor,
                  shape: BoxShape.circle,
                ),
                // This icon is now just a visual cue.
                child: const Icon(Icons.edit, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}