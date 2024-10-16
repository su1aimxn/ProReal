import 'package:flutter/material.dart';
import 'package:frontend/controllers/event_service.dart';
import 'package:frontend/models/event_model.dart';
import 'package:frontend/pages/edit_event.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final EventService _eventService = EventService();
  List<EventModel> _events = [];
  String _filter = 'วันนี้';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final events = await _eventService.getEvents();
      setState(() {
        _events = _applyFilter(events);
        _events.sort((a, b) => a.eventDate.compareTo(b.eventDate)); // Sort events by date
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading events: $e');
    }
  }

  List<EventModel> _applyFilter(List<EventModel> events) {
    DateTime now = DateTime.now();
    switch (_filter) {
      case 'วันนี้':
        return events.where((event) => event.eventDate.isAtSameMomentAs(DateTime(now.year, now.month, now.day))).toList();
      case 'สัปดาห์นี้':
        DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
        return events.where((event) => event.eventDate.isAfter(startOfWeek) && event.eventDate.isBefore(endOfWeek)).toList();
      case 'เดือนนี้':
        DateTime startOfMonth = DateTime(now.year, now.month, 1);
        DateTime endOfMonth = DateTime(now.year, now.month + 1, 0);
        return events.where((event) => event.eventDate.isAfter(startOfMonth) && event.eventDate.isBefore(endOfMonth)).toList();
      case 'ปีนี้':
        DateTime startOfYear = DateTime(now.year, 1, 1);
        DateTime endOfYear = DateTime(now.year + 1, 1, 0);
        return events.where((event) => event.eventDate.isAfter(startOfYear) && event.eventDate.isBefore(endOfYear)).toList();
      default:
        return events;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: const Text('กิจกรรม', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
  automaticallyImplyLeading: false, // This removes the back arrow
  actions: [
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<String>(
        value: _filter,
        icon: Icon(Icons.filter_list, color: Color.fromARGB(255, 153, 214, 255)),
        dropdownColor: const Color.fromARGB(255, 153, 214, 255),
        underline: Container(),
        style: TextStyle(color: Colors.black87, fontSize: 16),
        items: const [
          DropdownMenuItem(child: Text('วันนี้'), value: 'วันนี้'),
          DropdownMenuItem(child: Text('สัปดาห์นี้'), value: 'สัปดาห์นี้'),
          DropdownMenuItem(child: Text('เดือนนี้'), value: 'เดือนนี้'),
          DropdownMenuItem(child: Text('ปีนี้'), value: 'ปีนี้'),
        ],
        onChanged: (value) {
          setState(() {
            _filter = value!;
            _loadEvents(); // Reload events with the new filter
          });
        },
      ),
    ),
  ],
),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _events.isEmpty
              ? const Center(child: Text('ไม่มีข้อมูลกิจกรรม', style: TextStyle(fontSize: 18, color: Colors.grey)))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: _events.length,
                    itemBuilder: (context, index) {
                      final event = _events[index];
                      return Card(
                        elevation: 8,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: Icon(Icons.event, color: Colors.blueAccent),
                          title: Text(
                            event.eventName.isNotEmpty ? event.eventName : 'ไม่มีชื่อ',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
                          ),
                          subtitle: Text(
                            '${event.description ?? 'ไม่มีรายละเอียด'}\nวันที่: ${event.eventDate}\nเริ่มเวลา: ${event.startTime}\nสิ้นสุดเวลา: ${event.endTime}',
                            style: TextStyle(color: Colors.grey[700], fontSize: 16),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditEvent(event: event),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Event page is selected
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
              // Current page (do nothing)
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/notifications');
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
