import 'package:flutter/material.dart';
import 'package:frontend/controllers/auth_service.dart';
import 'package:frontend/models/user_model.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final response = await _authService.getCurrentUser();
      setState(() {
        _user = response;
      });
    } catch (e) {
      print('Error loading user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user data: $e')),
      );
    }
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('คุุณแน่ใจหรือไหมที่จะออกจะระบบ?'),
          actions: <Widget>[
            TextButton(
              child: Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop(false); // Return false when canceled
              },
            ),
            ElevatedButton(
              child: Text('ยืนยัน',style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.of(context).pop(true); // Return true when confirmed
              },
            ),
          ],
        );
      },
    );
    
    if (shouldLogout ?? false) {
      await _authService.logOut();
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF004AAD),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Profile Image with Gradient
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade200, Colors.blue.shade800],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/man.png'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Name
              Text(
                '${_user!.name} ${_user!.lname}',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004AAD),
                    ),
              ),
              const SizedBox(height: 8),

              // Divider
              Divider(
                thickness: 2,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 16),

              // User Information Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Username
                      Row(
                        children: [
                          Icon(Icons.person_outline, color: Colors.blue.shade800, size: 28),
                          const SizedBox(width: 12),
                          Text(
                            'ชื่อผู้ใช้: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blue.shade800,
                            ),
                          ),
                          Text(
                            _user!.userName,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Role
                      Row(
                        children: [
                          Icon(Icons.work_outline, color: Colors.blue.shade800, size: 28),
                          const SizedBox(width: 12),
                          Text(
                            'ตำแหน่ง: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blue.shade800,
                            ),
                          ),
                          Text(
                            _user!.role,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Email
                      Row(
                        children: [
                          Icon(Icons.email_outlined, color: Colors.blue.shade800, size: 28),
                          const SizedBox(width: 12),
                          Text(
                            'อีเมล: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blue.shade800,
                            ),
                          ),
                          Text(
                            _user!.email,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Logout Button with confirmation
              ElevatedButton(
                onPressed: _confirmLogout, // Show confirmation dialog before logout
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                ),
                child: Text(
                  'Logout',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 3, // Profile is selected
        selectedItemColor: Color(0xFF004AAD),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          // Handle navigation based on the index
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/events');
              break;
            case 2:
              Navigator.pushNamed(context, '/notifications');
              break;
            case 3:
              break;
          }
        },
      ),
    );
  }
}
