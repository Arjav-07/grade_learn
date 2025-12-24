import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  // --- CSV EXPORT LOGIC ---
  void _exportToCSV(List<QueryDocumentSnapshot> docs) {
    if (docs.isEmpty) return;
    String csvData = "Name,Email,Item,Type,Status,Date\n";
    for (var doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      csvData += "${data['name']},${data['email']},${data['itemTitle']},${data['type']},${data['status']},${data['appliedAt']?.toDate()}\n";
    }
    Share.share(csvData, subject: 'Application_Data_Export.csv');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFF9),
      appBar: AppBar(
        title: const Text("ADMIN CONSOLE",
            style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2)),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('applications').snapshots(),
            builder: (context, snapshot) {
              return IconButton(
                icon: const Icon(Icons.download_rounded),
                onPressed: () => snapshot.hasData ? _exportToCSV(snapshot.data!.docs) : null,
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          _buildSummaryStats(),
          _buildSearchBar(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              // NOTICE: We removed .orderBy here to fix the empty list error
              stream: FirebaseFirestore.instance.collection('applications').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.black));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("NO APPLICATIONS FOUND",
                      style: TextStyle(fontWeight: FontWeight.w900, color: Colors.grey)));
                }

                // --- MANUAL SORTING IN DART ---
                final allDocs = snapshot.data!.docs.toList();
                allDocs.sort((a, b) {
                  final aTime = (a.data() as Map)['appliedAt'] as Timestamp?;
                  final bTime = (b.data() as Map)['appliedAt'] as Timestamp?;
                  return (bTime ?? Timestamp.now()).compareTo(aTime ?? Timestamp.now());
                });

                // --- SEARCH FILTER ---
                final filteredDocs = allDocs.where((doc) {
                  final name = (doc['name'] ?? '').toString().toLowerCase();
                  return name.contains(_searchQuery.toLowerCase());
                }).toList();

                if (filteredDocs.isEmpty) {
                  return const Center(child: Text("NO MATCHING APPLICANTS"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    final data = filteredDocs[index].data() as Map<String, dynamic>;
                    final String docId = filteredDocs[index].id;
                    return _buildBrutalAdminCard(context, data, docId);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- SEARCH BAR WITH CLEAR BUTTON ---
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: "SEARCH APPLICANTS...",
          prefixIcon: const Icon(Icons.search, color: Colors.black),
          suffixIcon: _searchQuery.isNotEmpty 
            ? IconButton(
                icon: const Icon(Icons.clear, color: Colors.black),
                onPressed: () {
                  _searchController.clear();
                  setState(() => _searchQuery = "");
                },
              )
            : null,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 2), borderRadius: BorderRadius.circular(15)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 2.5), borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

  // --- STATS HELPER ---
  Widget _buildSummaryStats() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('applications').snapshots(),
      builder: (context, snapshot) {
        int total = snapshot.hasData ? snapshot.data!.docs.length : 0;
        int approved = snapshot.hasData 
            ? snapshot.data!.docs.where((d) => (d.data() as Map)['status'] == 'approved').length : 0;
        int pending = total - approved;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              _statBox("TOTAL", total.toString(), const Color(0xFFB5D8FF)),
              const SizedBox(width: 8),
              _statBox("APPROVED", approved.toString(), const Color(0xFF3CE5C4)),
              const SizedBox(width: 8),
              _statBox("PENDING", pending.toString(), const Color(0xFFFDE798)),
            ],
          ),
        );
      },
    );
  }

  Widget _statBox(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
            color: color,
            border: Border.all(width: 2),
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [BoxShadow(offset: Offset(3, 3))]),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 9)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 22)),
          ],
        ),
      ),
    );
  }

  Widget _buildBrutalAdminCard(BuildContext context, Map<String, dynamic> data, String docId) {
    final String status = data['status'] ?? 'pending';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 2.5),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text((data['itemTitle'] ?? 'UNTITLED').toString().toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                    Text("NAME: ${data['name'] ?? 'N/A'}",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () => _showDetailsDialog(context, data),
              )
            ],
          ),
          const Divider(height: 24, thickness: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statusActionBtn(docId, 'pending', Colors.orange, status == 'pending'),
              _statusActionBtn(docId, 'approved', Colors.green, status == 'approved'),
              _statusActionBtn(docId, 'rejected', Colors.red, status == 'rejected'),
              if (data['resumeUrl'] != null)
                IconButton(
                  onPressed: () => launchUrl(Uri.parse(data['resumeUrl'])),
                  icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
                ),
              IconButton(
                onPressed: () => _deleteApplication(context, docId),
                icon: const Icon(Icons.delete_forever),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _showDetailsDialog(BuildContext context, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(width: 2)),
        title: Text(data['name'].toString().toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("EMAIL: ${data['email']}", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("ITEM: ${data['itemTitle']}"),
            Text("TYPE: ${data['type'].toString().toUpperCase()}"),
            Text("DATE: ${data['appliedAt']?.toDate().toString().split(' ')[0]}"),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CLOSE", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _statusActionBtn(String docId, String targetStatus, Color activeColor, bool isActive) {
    return ElevatedButton(
      onPressed: () => FirebaseFirestore.instance.collection('applications').doc(docId).update({'status': targetStatus}),
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? activeColor : Colors.white,
        foregroundColor: isActive ? Colors.white : Colors.black,
        elevation: 0,
        side: const BorderSide(color: Colors.black, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      child: Text(targetStatus.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 9)),
    );
  }

  void _deleteApplication(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("DELETE?", style: TextStyle(fontWeight: FontWeight.w900)),
        content: const Text("This action cannot be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
          TextButton(
            onPressed: () {
              FirebaseFirestore.instance.collection('applications').doc(docId).delete();
              Navigator.pop(context);
            },
            child: const Text("DELETE", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}