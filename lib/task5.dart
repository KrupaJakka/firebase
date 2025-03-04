import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: ProfileScreen()));
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  String? _imageUrl;
  bool _isLoading = false;
  final picker = ImagePicker();
  final _nameController = TextEditingController();
  final _roleController = TextEditingController();
  final _mobileController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
      await uploadImage();
    }
  }

  Future uploadImage() async {
    if (_image == null) return;
    setState(() => _isLoading = true);
    try {
      String fileName = "profile_${_auth.currentUser!.uid}";
      Reference ref =
          FirebaseStorage.instance.ref().child('profile_images/$fileName.jpg');
      UploadTask uploadTask = ref.putFile(_image!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      setState(() => _imageUrl = downloadUrl);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update({'imageUrl': _imageUrl});
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Image Upload Failed!")));
    }
    setState(() => _isLoading = false);
  }

  Future updateProfile() async {
    String uid = _auth.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': _nameController.text,
      'role': _roleController.text,
      'mobile': _mobileController.text,
      'imageUrl': _imageUrl ?? "https://wallpapercave.com/wp/yiN28Ah.jpg",
    }, SetOptions(merge: true));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Profile Updated Successfully!"),
        action: SnackBarAction(label: "OK", onPressed: () {}),
      ),
    );
  }

  Future<void> getUserData() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get();
    if (doc.exists) {
      setState(() {
        _nameController.text = doc['name'] ?? '';
        _roleController.text = doc['role'] ?? '';
        _mobileController.text = doc['mobile'] ?? '';
        _imageUrl = doc['imageUrl'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Profile Update",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: pickImage,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        _imageUrl != null ? NetworkImage(_imageUrl!) : null,
                    child: _imageUrl == null
                        ? Icon(Icons.camera_alt,
                            size: 50, color: Colors.deepOrange)
                        : null,
                  ),
                  if (_isLoading)
                    CircularProgressIndicator(
                      color: Colors.deepOrange,
                    ),
                ],
              ),
            ),
            SizedBox(height: 20),
            buildTextField("Name", Icons.person, _nameController),
            SizedBox(height: 15),
            buildTextField("Role", Icons.work, _roleController),
            SizedBox(height: 15),
            buildTextField("Mobile", Icons.phone, _mobileController,
                isPhone: true),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text("Update Profile",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
      String label, IconData icon, TextEditingController controller,
      {bool isPhone = false}) {
    return TextField(
      controller: controller,
      keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepOrange),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
