import 'package:flutter/material.dart';
import 'package:grade_learn/models/workshop_model.dart';


class WorkshopDetailsPage extends StatelessWidget {
  final WorkshopData data;
  const WorkshopDetailsPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
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


            //---------------Header Card---------------//
            _CustomCard(
              color: const Color(0xFFE3F2FD),
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: Colors.black,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.code,
                        size: 40,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Text(data.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 10),
                  Text("WITH ${data.instructor}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 30),

            //---------------Info Tiles---------------//
            
            const _SectionHeader(title: 'WORKSHOP DETAILS'),
            const SizedBox(height: 12),
            _infoTile("DATE", data.date),
            _infoTile("DURATION", data.duration),
            _infoTile("AVAILABILITY", "${data.seatsLeft} / ${data.totalSeats} SEATS LEFT"),
            const SizedBox(height: 20),

            //---------------Description---------------//
            _CustomCard(
              color: Colors.white,
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(title: "ABOUT WORKSHOP"),
                  const SizedBox(height: 12),
                  Text('JOIN US FOR AN INTENSIVE HANDS-ON WORKSHOP WHERE YOU\'LL BUILD A COMPLETE FULL-STACK APPLICATION USING MONGODB, EXPRESS, REACT, AND NODE.JS. PERFECT FOR DEVELOPERS LOOKING TO MASTER THE MERN STACK.',
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            //---------------TOPIC COVERED---------------//
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: const _SectionHeader(title: "QUALIFICATIONS"),
            ),
            const SizedBox(height: 8),
            _CustomCard(
              color: const Color(0xFFFDE798),
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _includeRow(Icons.mark_email_read,"SETTING UP MERN ENVIRONMENT",),
                  _includeRow(Icons.mark_email_read,"BUILDING RESTFUL APIS WITH EXPRESS",),
                  _includeRow(Icons.mark_email_read, "REACT FRONTEND DEVELOPMENT"),
                  _includeRow(Icons.mark_email_read,"MONGODB DATABASE INTEGRATION",),
                  _includeRow(Icons.mark_email_read,"AUTHENTICATION WITH JWT",),
                  _includeRow(Icons.mark_email_read,"DEPLOYMENT STRATEGIES",),
                ],
              ),
            ),
            SizedBox(height: 20),


            // --- INSTRUCTOR ---
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: const _SectionHeader(title: "YOUR INSTRUCTOR"),
            ),
            _CustomCard(
              color: Colors.white,
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  Row(children: [
                    const CircleAvatar(radius: 25, backgroundColor: Colors.black, child: Icon(Icons.person, color: Colors.white)),
                    const SizedBox(width: 15),
                    const Text("SARAH MITCHELL", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                  ]),
                  const SizedBox(height: 10),
                  const Text("EXPERT JAVA DEVELOPER WITH 10 YEARS OF EXPERIENCE.", style: TextStyle(fontSize: 14)),
                ],
              ),
            ),

            const SizedBox(height: 20),
            //---------------Reserve Button---------------//

            //---------------Reserve Button---------------//
Builder(builder: (context) {
  // Logic to determine if seats are gone
  final bool isFull = data.seatsLeft == 0 || data.type == "FULL" || data.type == "LIVE";

  return ElevatedButton(
    onPressed: isFull ? null : () {
      // Handle reservation logic here
    },
    style: ElevatedButton.styleFrom(
      // Swap colors if full: White background, Black border
      backgroundColor: isFull ? Colors.white : Colors.black,
      foregroundColor: isFull ? Colors.black : Colors.white,
      disabledBackgroundColor: Colors.white, // Ensures background stays white when disabled
      disabledForegroundColor: Colors.black, // Ensures text stays black when disabled
      minimumSize: const Size(double.infinity, 64),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.black, width: isFull ? 2.5 : 0),
      ),
      elevation: 0,
    ),
    child: Text(
      isFull ? "NO SEATS LEFT" : "RESERVE MY SPOT",
      style: const TextStyle(
        fontSize: 18, 
        fontWeight: FontWeight.w900,
      ),
    ),
  );
}),
          ],
        ),
      ),
    );
  }

  


  


  
}


//------------------UI COMPONENTS------------------//
class _CustomCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final EdgeInsets padding;

  const _CustomCard({
    required this.child,
    required this.color,
    required this.padding,
  });

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

  class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

Widget _includeRow(IconData icon, String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22),
        const SizedBox(width: 12),

        // 🔥 OVERFLOW FIX
        Expanded(
          child: Text(
            text,
            softWrap: true,
            maxLines: 2, // increase if needed
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              height: 1.4,
            ),
          ),
        ),
      ],
    ),
  );
}