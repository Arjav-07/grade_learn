import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ApplicationForm extends StatefulWidget {
  final String title;
  final String type; // 'internship' or 'workshop'
  final String itemId;

  const ApplicationForm({
    super.key, 
    required this.title, 
    required this.type, 
    required this.itemId
  });

  @override
  State<ApplicationForm> createState() => _ApplicationFormState();
}

class _ApplicationFormState extends State<ApplicationForm> {
  // Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _locationController = TextEditingController();
  final _instituteController = TextEditingController();
  final _domainController = TextEditingController();
  final _specializationController = TextEditingController();
  final _gradYearController = TextEditingController();

  // State Variables
  String? _gender;
  String? _profession; 
  bool _isDifferentlyAbled = false;
  bool _termsAccepted = false;
  File? _resumeFile;
  bool _isUploading = false;
  String? _fileName;

  @override
  void initState() {
    super.initState();
    _loadUserInitialData();
  }

  void _loadUserInitialData() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        String fullDisplayName = user.displayName ?? "";
        List<String> parts = fullDisplayName.split(' ');
        _firstNameController.text = parts.isNotEmpty ? parts[0] : "";
        _lastNameController.text = parts.length > 1 ? parts.sublist(1).join(' ') : "";
        _emailController.text = user.email ?? "";
      });
    }
  }

  Future<void> _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      final file = File(result.files.single.path!);
      final fileSize = await file.length();
      if (fileSize > 2 * 1024 * 1024) {
        _showSnackBar("FILE TOO LARGE. MAX 2MB.", isError: true);
        return;
      }
      setState(() {
        _resumeFile = file;
        _fileName = result.files.single.name;
      });
    }
  }

  Future<void> _submitData() async {
    final bool isWorkshop = widget.type == 'workshop';

    // 1. Validations
    if (!_termsAccepted) {
      _showSnackBar("PLEASE ACCEPT TERMS AND CONDITIONS.", isError: true);
      return;
    }
    if (_firstNameController.text.trim().isEmpty) {
      _showSnackBar("FIRST NAME IS REQUIRED.", isError: true);
      return;
    }
    // Resume is ONLY mandatory for internships
    if (!isWorkshop && _resumeFile == null) {
      _showSnackBar("RESUME IS REQUIRED FOR INTERNSHIPS.", isError: true);
      return;
    }

    // Confirmation Dialog
    bool confirm = await _showConfirmDialog();
    if (!confirm) return;

    setState(() => _isUploading = true);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final workshopRef = FirebaseFirestore.instance.collection('workshops').doc(widget.itemId);
    final applicationRef = FirebaseFirestore.instance.collection('applications').doc("${user.uid}_${widget.itemId}");

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // 2. Duplicate Check
        DocumentSnapshot appCheck = await transaction.get(applicationRef);
        if (appCheck.exists) throw Exception("YOU ARE ALREADY REGISTERED!");

        // 3. Seat Logic for Workshops
        // Inside _submitData transaction block
if (isWorkshop) {
  // Inside the runTransaction block
DocumentSnapshot workshopSnap = await transaction.get(workshopRef);
if (!workshopSnap.exists) throw Exception("WORKSHOP NOT FOUND IN FIREBASE!");

// Use 'seatsLeft' to match your JSON and Console
int currentSeats = workshopSnap['seatsLeft'] ?? 0; 

if (currentSeats <= 0) throw Exception("WORKSHOP IS FULL!");

transaction.update(workshopRef, {'seatsLeft': currentSeats - 1});
}

        // 4. Conditional Resume Upload
        String? pdfUrl;
        if (!isWorkshop && _resumeFile != null) {
          final storageRef = FirebaseStorage.instance.ref().child('resumes/${user.uid}_${widget.itemId}.pdf');
          await storageRef.putFile(_resumeFile!);
          pdfUrl = await storageRef.getDownloadURL();
        }

        // 5. Final Save
        transaction.set(applicationRef, {
          'userId': user.uid,
          'itemId': widget.itemId,
          'itemTitle': widget.title,
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'email': _emailController.text,
          'status': isWorkshop ? 'approved' : 'pending', //
          'resumeUrl': pdfUrl,
          'appliedAt': FieldValue.serverTimestamp(),
          if (!isWorkshop) ...{
             'gender': _gender,
             'profession': _profession,
             'location': _locationController.text.trim(),
             'instituteName': _instituteController.text.trim(),
             'domain': _domainController.text.trim(),
             'specialization': _specializationController.text.trim(),
             'graduatingYear': _gradYearController.text.trim(),
             'differentlyAbled': _isDifferentlyAbled,
          }
        });
      });

      if (mounted) _showSuccessDialog();
    } catch (e) {
      _showSnackBar(e.toString().replaceAll("Exception: ", ""), isError: true);
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  // --- UI COMPONENTS ---

  @override
  Widget build(BuildContext context) {
    final bool isWorkshop = widget.type == 'workshop';

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFF9),
      appBar: AppBar(
        title: Text(isWorkshop ? "WORKSHOP ENROLLMENT" : "INTERNSHIP APPLICATION", 
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
            const Divider(thickness: 2, color: Colors.black),
            const SizedBox(height: 20),

            if (!isWorkshop) ...[
              _buildLabel("UPLOAD CV / RESUME *"),
              _buildResumePicker(),
              const SizedBox(height: 24),
            ],

            Row(
              children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _buildLabel("FIRST NAME *"),
                  _buildTextField(_firstNameController, "FIRST NAME"),
                ])),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _buildLabel("LAST NAME"),
                  _buildTextField(_lastNameController, "LAST NAME"),
                ])),
              ],
            ),
            const SizedBox(height: 16),

            _buildLabel("EMAIL (LOCKED)"),
            _buildTextField(_emailController, "", isReadOnly: true),
            const SizedBox(height: 16),

            if (!isWorkshop) ...[
              _buildLabel("GENDER *"),
              _buildDropdown(["MALE", "FEMALE", "OTHER"], _gender, (val) => setState(() => _gender = val)),
              const SizedBox(height: 16),
              _buildLabel("LOCATION"),
              _buildTextField(_locationController, "CITY, STATE"),
              const SizedBox(height: 16),
              _buildLabel("INSTITUTE NAME"),
              _buildTextField(_instituteController, "UNIVERSITY"),
              const SizedBox(height: 16),
              _buildLabel("PROFESSION *"),
              _buildDropdown(["STUDENT", "PROFESSIONAL", "FRESHER"], _profession, (val) => setState(() => _profession = val)),
              const SizedBox(height: 16),
              _buildLabel("GRADUATING YEAR"),
              _buildTextField(_gradYearController, "YYYY", keyboardType: TextInputType.number, 
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)]),
              const SizedBox(height: 16),
            ],

            _buildBrutalTermsBox(isWorkshop),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _isUploading ? null : _submitData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 64),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: _isUploading 
                ? const CircularProgressIndicator(color: Colors.white) 
                : Text(isWorkshop ? "CONFIRM ENROLLMENT" : "SUBMIT APPLICATION", 
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPERS ---

  Widget _buildBrutalTermsBox(bool isWorkshop) {
    return Container(
      decoration: BoxDecoration(border: Border.all(width: 2), borderRadius: BorderRadius.circular(12), 
        color: _termsAccepted ? Colors.green[50] : Colors.white),
      child: CheckboxListTile(
        title: Text(isWorkshop ? "I AGREE TO ENROLL AND ATTEND THIS SESSION." : "I VERIFY ALL DATA PROVIDED IS ACCURATE.", 
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900)),
        value: _termsAccepted,
        activeColor: Colors.black,
        onChanged: (val) => setState(() => _termsAccepted = val!),
      ),
    );
  }

  Future<bool> _showConfirmDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(width: 2)),
        title: const Text("CONFIRM SUBMISSION", style: TextStyle(fontWeight: FontWeight.w900)),
        content: const Text("Check your details. You cannot change them after submitting."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("CANCEL")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("CONFIRM")),
        ],
      ),
    ) ?? false;
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(width: 2)),
        title: const Text("SUCCESS! 🎉", style: TextStyle(fontWeight: FontWeight.w900)),
        content: const Text("Done! Check your dashboard for the workshop link and timing."),
        actions: [
          TextButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); }, 
          child: const Text("OK", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900))),
        ],
      ),
    );
  }

  void _showSnackBar(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: isError ? Colors.red : Colors.black));
  }

  Widget _buildLabel(String text) => Padding(padding: const EdgeInsets.only(bottom: 8, left: 4), child: Text(text, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: Colors.black54)));

  Widget _buildTextField(TextEditingController controller, String hint, {bool isReadOnly = false, TextInputType? keyboardType, List<TextInputFormatter>? inputFormatters}) {
    return TextField(
      controller: controller,
      readOnly: isReadOnly,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: isReadOnly ? Colors.grey[200] : Colors.white,
        enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black, width: 2), borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black, width: 2.5), borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildDropdown(List<String> items, String? currentValue, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: currentValue,
      decoration: InputDecoration(enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black, width: 2), borderRadius: BorderRadius.circular(12))),
      items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildResumePicker() {
    return GestureDetector(
      onTap: _pickPDF,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, border: Border.all(width: 2), borderRadius: BorderRadius.circular(15), boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))]),
        child: Row(
          children: [
            const Icon(Icons.picture_as_pdf, color: Colors.red),
            const SizedBox(width: 15),
            Expanded(child: Text(_resumeFile == null ? "SELECT RESUME" : _fileName!, style: const TextStyle(fontWeight: FontWeight.w900))),
          ],
        ),
      ),
    );
  }
}