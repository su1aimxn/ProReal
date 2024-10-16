import 'package:flutter/material.dart';
import 'package:frontend/models/user_model.dart';

class viewUser extends StatefulWidget {
  final UserModel user;

  viewUser({required this.user}); // Accept user data in constructor

  @override
  _viewUserState createState() => _viewUserState();
}

class _viewUserState extends State<viewUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('USER'),
        backgroundColor: Color(0xFF004AAD),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Profile Image
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
                '${widget.user.name} ${widget.user.lname}',
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
                          Icon(Icons.person_outline, color: Colors.blue, size: 28),
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
                            widget.user.userName,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Role
                      Row(
                        children: [
                          Icon(Icons.work_outline, color: Colors.blue, size: 28),
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
                            widget.user.role,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Email
                      Row(
                        children: [
                          Icon(Icons.email_outlined, color: Colors.blue, size: 28),
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
                            widget.user.email,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Action Buttons
             
              
            ],
          ),
        ),
      ),
    );
  }
}
