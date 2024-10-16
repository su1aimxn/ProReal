import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 255, 255, 255), const Color.fromARGB(255, 255, 255, 255)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
          children: [
            Spacer(), // Spacer to push content down

            // Large Image centered
            Image.asset(
              'assets/3.png', // Replace with your image
              height: 300,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20),

            // Title and description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // Center text horizontally
                children: [
                  Text(
                    'ปฏิทินกิจกรรม',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'คณะนิติศาสตร์\nมหาวิทยาลัยทักษิณ',
                    textAlign: TextAlign.center, // Center align text
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),

            // Login button with gradient
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login'); // Navigate to LoginPage
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero, // Remove default padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color.fromARGB(223, 4, 15, 137), Colors.cyan], // Dark to light blue gradient
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      alignment: Alignment.center,
                      child: Text(
                        'เข้าสู่ระบบที่นี่',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Signup button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register'); // Navigate to RegisterPage
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: Colors.blue, width: 2), // Set the border color to blue
                  ),
                  child: Text(
                    'ลงทะเบียนที่นี่',
                    style: TextStyle(fontSize: 18, color: Colors.blue),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            Spacer(), // Spacer to push content up
          ],
        ),
      ),
    );
  }
}