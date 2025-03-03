import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  DateTime? _selectedDate;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _selectDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _register() async {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("All fields are required!")),
      );
      return;
    }

    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection("registrations").add({
          "name": _nameController.text,
          "email": user.email,
          "phone": _phoneController.text,
          "event_date":
              DateFormat("yyyy-MM-dd HH:mm:ss").format(_selectedDate!),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration Successful!")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Event Registration",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                  labelText: "Enter your name", border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                  labelText: "Enter your phone number",
                  border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
                hintText: user?.email ?? "Not logged in",
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text(
                _selectedDate == null
                    ? "Select Event Date & Time"
                    : "Selected Date: ${DateFormat("yyyy-MM-dd HH:mm").format(_selectedDate!)}",
              ),
              trailing: Icon(Icons.calendar_today),
              onTap: _selectDateTime,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              child: Text("Register", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
