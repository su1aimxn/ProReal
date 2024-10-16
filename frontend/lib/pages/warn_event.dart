import 'package:flutter/material.dart';
import 'package:frontend/controllers/event_service.dart';
import 'package:frontend/models/event_model.dart';
import 'package:intl/intl.dart'; // ใช้สำหรับการฟอร์แมตวันที่

class WarnEvent extends StatefulWidget {
  @override
  _WarnEventState createState() => _WarnEventState();
}

class _WarnEventState extends State<WarnEvent> {
  final EventService _eventService = EventService();
  List<EventModel> _events = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      final events = await _eventService.getEvents();
      setState(() {
        _events = events;
      });
    } catch (e) {
      print('Error loading events: $e');
    }
  }

  List<EventModel> _getUpcomingEvents() {
    final now = DateTime.now();
    final oneMonthLater = now.add(Duration(days: 30));
    final oneWeekLater = now.add(Duration(days: 7));
    final oneDayLater = now.add(Duration(days: 1));

    return _events.where((event) {
      final eventDate = event.eventDate;
      return eventDate.isBefore(oneMonthLater) &&
          (eventDate.isAfter(oneWeekLater) || eventDate.isAfter(oneDayLater));
    }).toList();
  }

  String _getTimeDifference(DateTime eventDate) {
    final now = DateTime.now();
    final difference = eventDate.difference(now);

    if (difference.inDays > 0) {
      return 'อีก ${difference.inDays} วัน';
    } else if (difference.inHours > 0) {
      return 'อีก ${difference.inHours} ชั่วโมง';
    } else if (difference.inMinutes > 0) {
      return 'อีก ${difference.inMinutes} นาที';
    } else {
      return 'ถึงเวลางานแล้ว!';
    }
  }

  @override
  Widget build(BuildContext context) {
    final upcomingEvents = _getUpcomingEvents();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // ซ่อนปุ่มย้อนกลับ
        title: Text('การแจ้งเตือนกิจกรรม', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: upcomingEvents.length,
          itemBuilder: (context, index) {
            final event = upcomingEvents[index];
            final eventDateFormatted = DateFormat('yyyy-MM-dd').format(event.eventDate);
            final timeDifference = _getTimeDifference(event.eventDate);

            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: Icon(Icons.warning, color: Colors.red, size: 40),
                title: Text(
                  event.eventName.isNotEmpty ? event.eventName : 'ไม่มีชื่อกิจกรรม',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
                ),
                subtitle: Text(
                  'วันที่: $eventDateFormatted\nเวลา: ${event.startTime} - ${event.endTime}\nกิจกรรมจะถึงใน$timeDifference',
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Notifications page is selected
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'หน้าแรก'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'กิจกรรม'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'การแจ้งเตือน'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'โปรไฟล์'),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/events');
              break;
            case 2:
              // Current page (do nothing)
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
}
