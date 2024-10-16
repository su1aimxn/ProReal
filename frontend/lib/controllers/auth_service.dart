import 'dart:convert';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/varibles.dart'; // Ensure this path is correct
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Login method
 Future<UserModel?> login(String username, String password) async {
  final response = await http.post(
    Uri.parse("$apiURL/api/auth/login"),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, String>{
      'user_name': username,
      'password': password,
    }),
  );

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
  print('Response headers: ${response.headers}');

  if (response.statusCode == 200) {
    final contentType = response.headers['content-type'];
    if (contentType != null && contentType.contains('application/json')) {
      final data = jsonDecode(response.body);
      await _storeTokens(data['accessToken'], data['refreshToken']);
      final user = UserModel.fromJson(data['user']);
      print('Login successful: ${user.name} ${user.lname}');
      return user;
    } else {
      throw Exception('Unexpected content type: $contentType');
    }
  } else {
    final error = jsonDecode(response.body)['message'] ?? 'Failed to login';
    print('Login error: $error');
    throw Exception(error);
  }
}

  // Register method
  Future<void> register(String username, String password, String name, String lname, String role, String email) async {
    final response = await http.post(
      Uri.parse("$apiURL/api/auth/register"),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'user_name': username,
        'password': password,
        'name': name,
        'lname': lname,
        'role': role,
        'email': email,
      }),
    );

    if (response.statusCode == 201) {
      print('User registered successfully: $name $lname'); // Print success message
    } else {
      final error = jsonDecode(response.body)['message'] ?? 'Failed to register';
      print('Register error: $error'); // Print error message
      throw Exception(error);
    }
  }

  // Get all users method
  Future<List<UserModel>> getAllUsers() async {
    final response = await http.get(
      Uri.parse("$apiURL/api/auth/users"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await _getAccessToken()}', // Include token
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final users = data.map((user) => UserModel.fromJson(user)).toList();
      for (var user in users) {
        print('User fetched: ${user.name} ${user.lname}'); // Print user details
      }
      return users;
    } else {
      final error = jsonDecode(response.body)['message'] ?? 'Failed to load users';
      print('Fetch users error: $error'); // Print error message
      throw Exception(error);
    }
  }
Future<bool> updateUser(String id, String name, String? lname, String role, String email) async {
  try {
    final response = await http.put(
      Uri.parse("$apiURL/api/auth/users/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await _getAccessToken()}',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'lname': lname,
        'role': role,
        'email': email,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return true;
    } else {
      final responseJson = jsonDecode(response.body);
      final error = responseJson['error'] ?? 'Failed to update user';
      throw Exception(error);
    }
  } catch (e) {
    print('Error updating user: $e');
    return false;
  }
}
Future<bool> deleteUser(String id) async {
  try {
    final response = await http.delete(
      Uri.parse("$apiURL/api/auth/users/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await _getAccessToken()}',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return true;
    } else {
      final responseJson = jsonDecode(response.body);
      final error = responseJson['error'] ?? 'Failed to delete user';
      throw Exception(error);
    }
  } catch (e) {
    print('Error deleting user: $e');
    return false;
  }
}



Future<UserModel> getCurrentUser() async {
  try {
    final response = await http.get(
      Uri.parse("$apiURL/api/auth/me"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await _getAccessToken()}', // Include token
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Raw response data: $data'); // Print the entire response data

      // Log fields to verify response data
      final name = data['name'] ?? 'No name';
      final lname = data['lname']; // Nullable last name
      print('Name from response: $name');
      print('Lname from response: $lname');

      final user = UserModel.fromJson(data);
      print('Current user: ${user.name} ${user.lname ?? 'No lname'}'); // Handle optional lname
      return user;
    } else {
      final error = jsonDecode(response.body)['message'] ?? 'Failed to load current user';
      throw Exception(error);
    }
  } catch (e) {
    if (e is FormatException) {
      throw Exception('Server returned an unexpected response format');
    } else {
      throw Exception('Failed to load current user: $e');
    }
  }
}


  // Function to store tokens
  Future<void> _storeTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('refreshToken', refreshToken);
  }

  // Function to get access token
  Future<String> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken') ?? '';
  }

  // Logout method
  Future<void> logOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('accessToken');
      await prefs.remove('refreshToken');
      print('User logged out successfully'); // Print success message
    } catch (e) {
      print('Error logging out: $e'); // Print error message
      throw Exception('Failed to log out');
    }
  }
}


 Future<void> addUser(String username, String password, String name, String lname, String role, String email) async {
    final response = await http.post(
      Uri.parse("$apiURL/api/auth//users/add"),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'user_name': username,
        'password': password,
        'name': name,
        'lname': lname,
        'role': role,
        'email': email,
      }),
    );

    if (response.statusCode == 201) {
      print('Add success: $name $lname'); // Print success message
    } else {
      final error = jsonDecode(response.body)['message'] ?? 'Failed to AddUser';
      print('AddUser error: $error'); // Print error message
      throw Exception(error);
    }
  }