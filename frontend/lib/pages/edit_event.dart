import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend/controllers/event_service.dart';
import 'package:frontend/models/event_model.dart';

class EditEvent extends StatefulWidget {
  final EventModel event;

  EditEvent({required this.event});

  @override
  _EditEventState createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  final _formKey = GlobalKey<FormState>();
  final EventService _eventService = EventService();

  late TextEditingController _titleController;
  late TextEditingController _dateController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  late TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event.eventName);
    _dateController = TextEditingController(text: DateFormat('dd/MM/yyyy').format(widget.event.eventDate));
    _startTimeController = TextEditingController(text: widget.event.startTime);
    _endTimeController = TextEditingController(text: widget.event.endTime);
    _descController = TextEditingController(text: widget.event.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _selectDate(BuildContext context) async {
    DateTime initialDate = DateFormat('dd/MM/yyyy').parse(_dateController.text);

    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      setState(() {
        _dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
      });
    }
  }

  void _selectTime(BuildContext context, TextEditingController controller) async {
    TimeOfDay initialTime = TimeOfDay(
      hour: int.parse(controller.text.split(':')[0]),
      minute: int.parse(controller.text.split(':')[1]),
    );

    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (selectedTime != null) {
      setState(() {
        controller.text = selectedTime.format(context);
      });
    }
  }

  void _saveEvent() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _eventService.updateEvent(
          widget.event.id,
          _titleController.text,
          _descController.text,
          DateFormat('dd/MM/yyyy').parse(_dateController.text),
          _startTimeController.text,
          _endTimeController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('อัปเดตกิจกรรมเรียบร้อย')));
        Navigator.pop(context, true); // Return to previous page with success
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ไม่สามารถอัปเดตกิจกรรมได้')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 254, 250),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        flexibleSpace: Stack(
          children: [
            Positioned(
              top: -50,
              left: -110,
              right: 270,
              child: Container(
                height: 100,
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
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'แก้ไขกิจกรรม',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.0),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _buildLabel('ชื่อกิจกรรม'),
                    _buildTextField(
                      controller: _titleController,
                      hintText: 'ชื่อกิจกรรม',
                      validator: (value) => value!.isEmpty ? 'กรุณาใส่ชื่อกิจกรรม' : null,
                    ),
                    SizedBox(height: 16.0),
                    _buildLabel('คำอธิบาย'),
                    _buildTextField(
                      controller: _descController,
                      hintText: 'คำอธิบาย',
                      validator: (value) => value!.isEmpty ? 'กรุณาใส่คำอธิบาย' : null,
                    ),
                    SizedBox(height: 16.0),
                    _buildLabel('วันที่'),
                    _buildTextField(
                      controller: _dateController,
                      hintText: 'dd/MM/yyyy',
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      validator: (value) => value!.isEmpty ? 'กรุณาเลือกวันที่' : null,
                      icon: Icons.calendar_today,
                    ),
                    SizedBox(height: 16.0),
                    _buildLabel('เวลาเริ่มต้น'),
                    _buildTextField(
                      controller: _startTimeController,
                      hintText: '00:00',
                      readOnly: true,
                      onTap: () => _selectTime(context, _startTimeController),
                      validator: (value) => value!.isEmpty ? 'กรุณาเลือกเวลาเริ่มต้น' : null,
                      icon: Icons.access_time,
                    ),
                    SizedBox(height: 16.0),
                    _buildLabel('เวลาสิ้นสุด'),
                    _buildTextField(
                      controller: _endTimeController,
                      hintText: '00:00',
                      readOnly: true,
                      onTap: () => _selectTime(context, _endTimeController),
                      validator: (value) => value!.isEmpty ? 'กรุณาเลือกเวลาสิ้นสุด' : null,
                      icon: Icons.access_time,
                    ),
                    SizedBox(height: 24.0),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color.fromARGB(223, 255, 207, 77), Colors.orange],
                          begin: Alignment.centerLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ElevatedButton(
                        onPressed: _saveEvent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save, color: Colors.white),
                            SizedBox(width: 8.0),
                            Text(
                              'บันทึกการเปลี่ยนแปลง',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber, // Set to transparent to show gradient
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          textStyle: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool readOnly = false,
    Function()? onTap,
    String? Function(String?)? validator,
    IconData? icon,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: icon != null ? Icon(icon) : null,
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
}
