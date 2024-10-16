import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/event_page.dart';
import 'pages/warn_event.dart';
import 'pages/profile_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/admin_dashboard.dart';
import 'pages/first_page.dart'; 
import 'pages/addUser.dart';// Import the FirstPage

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FirstPage(), // Set FirstPage as the default page
      debugShowCheckedModeBanner: false, // Remove the debug banner
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomePage(),
        '/events': (context) => EventPage(),
        '/notifications': (context) => WarnEvent(),
        '/profile': (context) => ProfilePage(),
        '/admin_dashboard': (context) => AdminDashboard(),
        '/addUser' : (context) => Adduser(), // Add route for admin dashboard
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => ErrorPage());
      },
    );
  }
}

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('404 Not Found'),
      ),
      body: Center(
        child: Text('Page not found'),
      ),
    );
  }
}