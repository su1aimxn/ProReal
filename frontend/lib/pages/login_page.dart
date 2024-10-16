import 'package:flutter/material.dart';
import 'package:frontend/controllers/auth_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  String? _errorMessage;
  bool _hasError = false;

  void _login() async {
    // Reset the error message and state before starting the login process
    setState(() {
      _errorMessage = null;
      _hasError = false;
    });

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        print('Username: ${_usernameController.text}');
        print('Password: ${_passwordController.text}');

        final user = await AuthService().login(
          _usernameController.text,
          _passwordController.text,
        );

        print('Login successful, user role: ${user?.role}');

        if (user != null) {
          if (user.role == 'admin') {
            Navigator.pushReplacementNamed(context, '/admin_dashboard');
          } else {
            Navigator.pushReplacementNamed(context, '/home');
          }
        } else {
          setState(() {
            _errorMessage = 'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง';
            _hasError = true; // Set the error state to true
            _passwordController.clear();
          });
        }
      } catch (error) {
        print('Login error: $error');

        setState(() {
          _errorMessage = 'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง';
          _hasError = true; // Set the error state to true
          _passwordController.clear();
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToRegister() {
    Navigator.pushNamed(context, '/register');
  }

  Future<void> _onRefresh() async {
    setState(() {
      _usernameController.clear();
      _passwordController.clear();
      _errorMessage = null;
      _hasError = false;
    });

    await Future.delayed(Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: Stack(
            children: [
              Positioned(
                top: -80,
                left: -100,
                right: 120,
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color.fromARGB(223, 4, 15, 137), Colors.cyan],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(200),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 95.0, right: 1.0),
                      child: Text(
                        'เข้าสู่ระบบ',
                        style: TextStyle(
                          fontSize: 35,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: 250),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _buildTextField(
                                controller: _usernameController,
                                labelText: 'ชื่อผู้ใช้',
                                icon: Icons.person,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณากรอกชื่อผู้ใช้';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 16),
                              _buildPasswordTextField(),
                              if (_errorMessage != null) ...[
                                SizedBox(height: 8),
                                Text(
                                  _errorMessage!,
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                              SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: _isLoading ? null : _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: _isLoading
                                    ? CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      )
                                    : Text(
                                        'เข้าสู่ระบบ',
                                        style: TextStyle(fontSize: 18, color: Colors.white),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('ยังไม่มีบัญชี?'),
                        TextButton(
                          onPressed: _navigateToRegister,
                          child: Text(
                            'สมัครสมาชิก',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _hasError ? Colors.red : Colors.blue), // Change color based on error
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _hasError ? Colors.red : Colors.blue), // Change color based on error
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _hasError ? Colors.red : Colors.blue), // Change color based on error
        ),
        suffixIcon: Icon(icon, color: Colors.black),
      ),
      validator: validator,
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: 'รหัสผ่าน',
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _hasError ? Colors.red : Colors.blue), // Change color based on error
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _hasError ? Colors.red : Colors.blue), // Change color based on error
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _hasError ? Colors.red : Colors.blue), // Change color based on error
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.black,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณากรอกรหัสผ่าน';
        }
        return null;
      },
    );
  }
}
