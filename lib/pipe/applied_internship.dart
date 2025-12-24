import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApplyInternshipPage extends StatefulWidget {
  final String roleTitle;
  const ApplyInternshipPage({super.key, required this.roleTitle});

  @override
  State<ApplyInternshipPage> createState() => _ApplyInternshipPageState();
}

class _ApplyInternshipPageState extends State<ApplyInternshipPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isSubmitting = false;

  /// Sends data to Google Sheets via Apps Script
  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      // Replace with your Google Apps Script Web App URL
      var url = Uri.parse('YOUR_GOOGLE_SCRIPT_WEB_APP_URL');
      
      var response = await http.post(url, body: {
        "name": _nameController.text,
        "email": _emailController.text,
        "role": widget.roleTitle,
      });

      if (response.body == "SUCCESS") {
        // Save locally that the user has applied for THIS role
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('applied_${widget.roleTitle}', true);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("APPLICATION SUBMITTED SUCCESSFULY!")),
          );
          Navigator.pop(context, true); // Return 'true' to refresh previous screen
        }
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFF9),
      appBar: AppBar(title: const Text("APPLY NOW", style: TextStyle(fontWeight: FontWeight.w900))),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("APPLYING FOR: ${widget.roleTitle}", 
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              _buildTextField("FULL NAME", _nameController),
              const SizedBox(height: 20),
              _buildTextField("EMAIL ADDRESS", _emailController),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitApplication,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: _isSubmitting 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("SUBMIT APPLICATION", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) => value!.isEmpty ? "Field Required" : null,
    );
  }
}