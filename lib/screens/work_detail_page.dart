import 'package:flutter/material.dart';
import 'package:grade_learn/models/workshop_model.dart';
import 'package:grade_learn/screens/application_from.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:async';

class WorkshopDetailsPage extends StatefulWidget {
  final WorkshopData data;
  const WorkshopDetailsPage({super.key, required this.data});

  @override
  State<WorkshopDetailsPage> createState() => _WorkshopDetailsPageState();
}

class _WorkshopDetailsPageState extends State<WorkshopDetailsPage> {
  late Timer _countdownTimer;

  @override
  void initState() {
    super.initState();
    // Update UI every minute to keep the "H & M" countdown accurate
    _countdownTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isActuallyFull = widget.data.seatsLeft <= 0;
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? "";

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFF9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "WORKSHOP DETAILS",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, letterSpacing: 1.1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- HEADER CARD ----------
            _CustomCard(
              color: const Color(0xFFE3F2FD),
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 42,
                    backgroundColor: Colors.black,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.code, size: 40, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.data.title.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "INSTRUCTOR: ${widget.data.instructor.toUpperCase()}",
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ---------- ENROLLMENT CONTENT LOCK ----------
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('applications')
                  .doc("${userId}_${widget.data.id}")
                  .snapshots(),
              builder: (context, snapshot) {
                bool isEnrolled = snapshot.hasData &&
                    snapshot.data!.exists &&
                    snapshot.data!['status'] == 'approved';

                if (!isEnrolled) {
                  return _buildLockedView(); 
                }

                return _buildUnlockedContent(widget.data); 
              },
            ),

            const SizedBox(height: 30),

            const _SectionHeader(title: 'LOGISTICS'),
            const SizedBox(height: 12),
            _infoTile("DATE", widget.data.date),
            _infoTile("DURATION", widget.data.duration),
            _infoTile("AVAILABILITY", "${widget.data.seatsLeft} / ${widget.data.totalSeats} SEATS LEFT"),

            const SizedBox(height: 24),

            _CustomCard(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionHeader(title: "ABOUT WORKSHOP"),
                  const SizedBox(height: 12),
                  Text(
                    widget.data.description,
                    style: const TextStyle(fontSize: 15, height: 1.6, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const _SectionHeader(title: "CURRICULUM"),
            const SizedBox(height: 8),
            _CustomCard(
              color: const Color(0xFFFDE798),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: widget.data.topics
                    .map((item) => _includeRow(Icons.check_circle_outline, item))
                    .toList(),
              ),
            ),

            const SizedBox(height: 30),

            // ---------- REGISTRATION ACTION ----------
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('applications')
                  .doc("${userId}_${widget.data.id}")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.exists) {
                  return _buildEnrolledBadge();
                }

                return ElevatedButton(
                  onPressed: isActuallyFull
                      ? null
                      : () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ApplicationForm(
                                title: widget.data.title,
                                type: 'workshop',
                                itemId: widget.data.id,
                              ),
                            ),
                          ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isActuallyFull ? Colors.white : Colors.black,
                    foregroundColor: isActuallyFull ? Colors.black : Colors.white,
                    disabledBackgroundColor: Colors.grey[200],
                    minimumSize: const Size(double.infinity, 64),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: Colors.black, width: 2),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    isActuallyFull ? "WORKSHOP FULL" : "RESERVE MY SPOT",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ---------- ENROLLED / UNLOCKED COMPONENTS ----------

  Widget _buildUnlockedContent(WorkshopData data) {
    // 1. Calculate Countdown
    DateTime now = DateTime.now();
    DateTime workshopDate = DateTime.parse(data.date); 
    Duration diff = workshopDate.difference(now);
    
    bool isCompleted = diff.isNegative;
    int hours = diff.inHours;
    int minutes = diff.inMinutes.remainder(60);

    return _CustomCard(
      color: isCompleted ? const Color(0xFFB5C0FF) : const Color(0xFF3CE5C4), 
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(isCompleted ? Icons.workspace_premium : Icons.lock_open_rounded, color: Colors.black),
                  const SizedBox(width: 10),
                  Text(isCompleted ? "COMPLETED" : "ENROLLED", 
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                ],
              ),
              // REAL-TIME COUNTDOWN
              if (!isCompleted) 
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)),
                  child: Text("${hours}H ${minutes}M LEFT", 
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
                ),
            ],
          ),
          const Divider(color: Colors.black, thickness: 2, height: 25),
          _infoText("SUBJECT", data.title), 
          _infoText("SCHEDULE", "${data.date} @ ${data.duration}"),
          const SizedBox(height: 15),

          if (isCompleted) 
            ElevatedButton.icon(
              onPressed: () => _generateCertificate(data),
              icon: const Icon(Icons.download, color: Colors.white),
              label: const Text("DOWNLOAD CERTIFICATE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, minimumSize: const Size(double.infinity, 54)),
            )
          else
            ElevatedButton(
              onPressed: () => launchUrl(Uri.parse(data.meetingLink)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("JOIN LIVE WORKSHOP", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
            ),
        ],
      ),
    );
  }

  // ---------- PDF GENERATOR ----------
  Future<void> _generateCertificate(WorkshopData workshop) async {
    final pdf = pw.Document();
    final user = FirebaseAuth.instance.currentUser;
    final appDoc = await FirebaseFirestore.instance.collection('applications').doc("${user?.uid}_${workshop.id}").get();

    final String name = appDoc.exists ? "${appDoc['firstName']} ${appDoc['lastName']}" : (user?.displayName ?? "Student");

    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4.landscape,
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Container(
            padding: const pw.EdgeInsets.all(30),
            decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black, width: 4)),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text("CERTIFICATE OF COMPLETION", style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.Text("Awarded to: $name", style: const pw.TextStyle(fontSize: 24)),
                pw.SizedBox(height: 10),
                pw.Text("For finishing the workshop: ${workshop.title}", style: const pw.TextStyle(fontSize: 18)),
                pw.SizedBox(height: 40),
                pw.Text("Date: ${workshop.date}"),
              ],
            ),
          ),
        );
      },
    ));

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  Widget _buildLockedView() {
    return _CustomCard(
      color: const Color(0xFFF5F5F5),
      padding: const EdgeInsets.all(20),
      child: const Column(
        children: [
          Icon(Icons.lock_person_rounded, size: 40, color: Colors.black54),
          SizedBox(height: 12),
          Text(
            "REGISTER TO UNLOCK THE MEETING LINK,\nTOPIC DETAILS, AND SCHEDULE.",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildEnrolledBadge() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 2.5),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 12),
          Text("YOU ARE ENROLLED", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        ],
      ),
    );
  }

  // ---------- UI HELPERS ----------
  Widget _infoText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text("$label: ${value.toUpperCase()}", style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
    );
  }

  Widget _infoTile(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(3, 3))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _includeRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, height: 1.4))),
        ],
      ),
    );
  }
}

class _CustomCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final EdgeInsets padding;
  const _CustomCard({required this.child, required this.color, required this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
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

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 12),
      child: Row(
        children: [
          Text(title, 
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 1.2))],
      ),
    );
  }
}