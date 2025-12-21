import 'package:flutter/material.dart';
import 'package:grade_learn/models/workshop_model.dart';

class WorkshopDetailsPage extends StatelessWidget {
  final WorkshopData data;
  const WorkshopDetailsPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final bool isFull = data.seatsLeft == 0 || data.type == "FULL" || data.type == "LIVE";

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFF9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("WORKSHOP DETAILS", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
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
                  Text(data.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 10),
                  Text("WITH ${data.instructor}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const _SectionHeader(title: 'WORKSHOP INFO'),
            const SizedBox(height: 12),
            _infoTile("DATE", data.date),
            _infoTile("DURATION", data.duration),
            _infoTile("AVAILABILITY", "${data.seatsLeft} / ${data.totalSeats} SEATS"),
            const SizedBox(height: 20),
            _CustomCard(
              color: Colors.white,
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionHeader(title: "ABOUT WORKSHOP"),
                  const SizedBox(height: 12),
                  Text(data.description, style: const TextStyle(fontSize: 16, height: 1.5)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const _SectionHeader(title: "TOPICS COVERED"),
            const SizedBox(height: 8),
            _CustomCard(
              color: const Color(0xFFFDE798),
              padding: EdgeInsets.zero,
              child: Column(
                children: data.topics.map((item) => _includeRow(Icons.mark_email_read, item)).toList(),
              ),
            ),
            const SizedBox(height: 20),
            const _SectionHeader(title: "YOUR INSTRUCTOR"),
            _CustomCard(
              color: Colors.white,
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  Row(children: [
                    const CircleAvatar(radius: 25, backgroundColor: Colors.black, child: Icon(Icons.person, color: Colors.white)),
                    const SizedBox(width: 15),
                    Text(data.instructor, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                  ]),
                  const SizedBox(height: 10),
                  Text(data.instructorBio, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: isFull ? null : () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: isFull ? Colors.white : Colors.black,
                foregroundColor: isFull ? Colors.black : Colors.white,
                disabledBackgroundColor: Colors.white,
                disabledForegroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 64),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.black, width: isFull ? 2.5 : 0),
                ),
                elevation: 0,
              ),
              child: Text(isFull ? "NO SEATS LEFT" : "RESERVE MY SPOT", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900)),
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
          Icon(icon, size: 22),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, height: 1.4))),
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

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 1.2))],
      ),
    );
  }
}