import 'package:flutter/material.dart';
import 'package:frontend/controllers/auth_service.dart';
import 'package:frontend/models/user_model.dart';

class EditUser extends StatefulWidget {
  final UserModel user;

  const EditUser({required this.user});

  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  late TextEditingController _nameController;
  late TextEditingController _lnameController;
  late TextEditingController _emailController;
  late TextEditingController _usernameController;
  String? _selectedRole;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _lnameController = TextEditingController(text: widget.user.lname ?? '');
    _emailController = TextEditingController(text: widget.user.email);
    _usernameController = TextEditingController(text: widget.user.userName);
    _selectedRole = widget.user.role;
  }

  Future<void> _updateUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.user.id.isEmpty) {
        throw Exception("User ID is missing");
      }

      final success = await AuthService().updateUser(
        widget.user.id,
        _nameController.text,
        _lnameController.text,
        _selectedRole ?? '',
        _emailController.text,
      );

      if (success) {
        final updatedUser = UserModel(
          id: widget.user.id,
          userName: _usernameController.text,
          password: widget.user.password, // เก็บรหัสผ่านเดิม
          name: _nameController.text,
          lname: _lnameController.text,
          role: _selectedRole ?? '',
          email: _emailController.text,
        );

        Navigator.pop(context, updatedUser);
      } else {
        throw Exception("Failed to update user");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating user: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteUser() async {
    try {
      final success = await AuthService().deleteUser(widget.user.id);

      if (success) {
        Navigator.pop(context, true);
      } else {
        throw Exception("Failed to delete user");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting user: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 254, 250),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Stack(
          children: [
            Positioned(
              top: -50,
              left: -110,
              right: 270,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color.fromARGB(223, 255, 207, 77), Colors.orange],
                    begin: Alignment.bottomRight,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(200),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Text(
                      "แก้ไขข้อมูลผู้ใช้",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 24.0),
                  _buildTextField(
                    controller: _nameController,
                    hintText: "ชื่อ",
                    labelText: "ชื่อ",
                  ),
                  SizedBox(height: 16.0),
                  _buildTextField(
                    controller: _lnameController,
                    hintText: "นามสกุล",
                    labelText: "นามสกุล",
                  ),
                  SizedBox(height: 16.0),
                  _buildTextField(
                    controller: _usernameController,
                    hintText: "ชื่อผู้ใช้",
                    labelText: "ชื่อผู้ใช้",
                  ),
                   SizedBox(height: 16.0),
                  _buildTextField(
                    controller: _emailController,
                    hintText: "อีเมล",
                    labelText: "อีเมล",
                  ),
                 
                  
                  SizedBox(height: 16.0),
                  _buildRoleDropdown(),
                  SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: _updateUser,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.amber,
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.save, color: Colors.white),
                        SizedBox(width: 8.0),
                        Text(
                          "บันทึกข้อมูล",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _deleteUser,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete, color: Colors.white),
                        SizedBox(width: 8.0),
                        Text(
                          "ลบผู้ใช้",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String labelText,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF00A9F0), width: 2.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  Widget _buildRoleDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedRole,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF00A9F0), width: 2.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      items: ['อาจารย์', 'บุคลากร', 'admin'].map((String role) {
        return DropdownMenuItem<String>(
          value: role,
          child: Text(role),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedRole = newValue;
        });
      },
    );
  }
}
