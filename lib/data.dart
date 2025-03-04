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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.indigo],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 10,
              color: Colors.white.withOpacity(0.95),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Event Registration",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person, color: Colors.teal),
                        labelText: "Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone, color: Colors.teal),
                        labelText: "Phone Number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email, color: Colors.teal),
                        labelText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: user?.email ?? "Not logged in",
                      ),
                    ),
                    SizedBox(height: 10),
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.teal),
                      ),
                      tileColor: Colors.teal.withOpacity(0.1),
                      title: Text(
                        _selectedDate == null
                            ? "Select Event Date & Time"
                            : "Selected: ${DateFormat("yyyy-MM-dd HH:mm").format(_selectedDate!)}",
                      ),
                      trailing: Icon(Icons.calendar_today, color: Colors.teal),
                      onTap: _selectDateTime,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 50,
                        ),
                      ),
                      child: Text(
                        "Register",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
