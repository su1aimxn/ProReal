import 'package:flutter/material.dart';
import 'package:frontend/controllers/auth_service.dart';
import 'BottomNVGB.dart';

class Adduser extends StatefulWidget {
  @override
  _AdduserState createState() => _AdduserState();
}

class _AdduserState extends State<Adduser> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  String? _selectedRole;
  int _currentIndex = 1; // Track the current index for the BottomNavigationBar

  Future<void> _refreshPage() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Adduser()),
    );
  }

  void _onBottomNavTap(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/admin_dashboard');
    } else if (index == 1) {
      // Stay on Adduser page
    }
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await AuthService().register(
          _usernameController.text,
          _passwordController.text,
          _nameController.text,
          _lnameController.text,
          _selectedRole!,
          _emailController.text,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เพิ่มสำเร็จ!')),
        );

        Navigator.pushReplacementNamed(context, '/admin_dashboard');
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('การเพิ่มล้มเหลว: $error')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: RefreshIndicator(
          onRefresh: _refreshPage,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Stack(
              children: [
                Positioned(
                  top: -150,
                  left: -50,
                  right: -50,
                  child: Container(
                    height: 300,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue, Colors.cyan],
                        begin: Alignment.bottomRight,
                        end: Alignment.bottomLeft,
                      ),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(200),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 40.0),
                        child: Text(
                          'เพิ่มผู้ใช้ใหม่',
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 150),
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
                                  controller: _nameController,
                                  labelText: 'ชื่อ',
                                  icon: Icons.person,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'กรุณากรอกชื่อ';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16),
                                _buildTextField(
                                  controller: _lnameController,
                                  labelText: 'นามสกุล',
                                  icon: Icons.person,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'กรุณากรอกนามสกุล';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16),
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
                                SizedBox(height: 16),
                                DropdownButtonFormField<String>(
                                  value: _selectedRole,
                                  items: [
                                    DropdownMenuItem(
                                      child: Text('อาจารย์'),
                                      value: 'อาจารย์',
                                    ),
                                    DropdownMenuItem(
                                      child: Text('บุคลากร'),
                                      value: 'บุคลากร',
                                    ),
                                    DropdownMenuItem(
                                      child: Text('admin'),
                                      value: 'admin',
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedRole = value!;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'สถานะ',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null) {
                                      return 'กรุณาเลือกสถานะ';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16),
                                _buildTextField(
                                  controller: _emailController,
                                  labelText: 'อีเมล',
                                  icon: Icons.email,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'กรุณากรอกอีเมล';
                                    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                        .hasMatch(value)) {
                                      return 'กรุณากรอกอีเมลที่ถูกต้อง';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 24),
                                ElevatedButton(
                                  onPressed: _isLoading ? null : _register,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 40),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        )
                                      : Text(
                                          'เพิ่มผู้ใช้',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: AdminBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
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
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
