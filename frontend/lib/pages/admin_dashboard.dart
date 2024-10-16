import 'package:flutter/material.dart';
import 'package:frontend/controllers/auth_service.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/pages/edit_user.dart'; // Import your EditUser page
import 'BottomNVGB.dart'; // Import your AdminBottomNavigationBar
import 'addUser.dart'; // Import AddUser page
import 'viewUser.dart'; // Import viewUser page

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List<UserModel> _users = [];
  bool _isLoading = true;
  int _currentIndex = 0; // To track the selected tab

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final users = await AuthService().getAllUsers(); // Assuming getAllUsers fetches user data
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _confirmDeleteUser(String userId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ยืนยันการลบ'),
          content: Text('คุณแน่ใจหรือไม่ว่าต้องการลบผู้ใช้นี้?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('ยกเลิก'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await _deleteUser(userId); // Call delete method
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Set background color to red
              ),
              child: Text(
                'ยืนยัน',
                style: TextStyle(color: Colors.white), // Set text color to white
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteUser(String userId) async {
    try {
      await AuthService().deleteUser(userId); // Ensure userId is correct
      setState(() {
        _users.removeWhere((user) => user.id == userId);
      });
    } catch (e) {
      print("Error deleting user: $e");
    }
  }

  void _editUser(UserModel user) async {
    final updatedUser = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditUser(user: user),
      ),
    );

    if (updatedUser != null) {
      setState(() {
        final index = _users.indexWhere((u) => u.id == updatedUser.id);
        if (index != -1) {
          _users[index] = updatedUser;
        }
      });
    }
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 1) {
      // Navigate to Add User Page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Adduser()), // Replace with AddUser page
      );
    } else if (index == 0) {
      _fetchUsers(); // Refresh AdminDashboard data
    }
  }

  // Method to show logout confirmation dialog
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ยืนยันการออกจากระบบ'),
          content: Text('คุณแน่ใจหรือไม่ว่าต้องการออกจากระบบ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('ยกเลิก'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await AuthService().logOut(); // Call the logout method
                Navigator.of(context).pushReplacementNamed('/login'); // Redirect to login page
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Set background color to red
              ),
              child: Text(
                'ออกจากระบบ',
                style: TextStyle(color: Colors.white), // Set text color to white
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable the back button
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _showLogoutConfirmationDialog(context); // Call the confirmation dialog
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue, Colors.cyan],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'แอปพลิเคชันปฏิทินกิจกรรมคณะนิติศาสตร์',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'คุณสามารถดู จัดเก็บ และแก้ไขปฏิทินกิจกรรมของคุณได้ในแอพพลิเคชันนี้!',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.calendar_today, size: 50, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
                Text(
                  'ข้อมูลผู้ใช้',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    decorationThickness: 2,
                    decorationColor: Color.fromARGB(0, 0, 0, 255),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView.builder(
                      itemCount: _users.length,
                      itemBuilder: (context, index) {
                        final user = _users[index];
                        return UserCard(
                          user: user,
                          onDelete: () => _confirmDeleteUser(user.id),
                          onEdit: () => _editUser(user),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: AdminBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const UserCard({
    required this.user,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, size: 30, color: Colors.white),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${user.name} ${user.lname ?? ''}',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    SizedBox(height: 5),
                    Text(user.role, style: TextStyle(fontSize: 14, color: Colors.black54)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => viewUser(user: user),
                      ),
                    );
                  },
                  icon: Icon(Icons.visibility, color: Colors.white),
                  label: Text('ดูข้อมูล', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 13, 154, 241),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: onEdit,
                  icon: Icon(Icons.edit, color: Colors.white),
                  label: Text('แก้ไข', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 233, 193, 61),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: onDelete,
                  icon: Icon(Icons.delete, color: Colors.white),
                  label: Text('ลบ', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
