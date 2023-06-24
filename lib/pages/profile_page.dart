import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_app/pages/chat_page.dart';
import 'package:login_app/pages/map.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;

  String username = ''; // User's username from Firebase
  String email = ''; // User's email from Firebase
  String profileImageUrl = ''; // User's profile image URL from Firebase

  //document ID's
  List<String> docIDs = [];

  //get docIDs
  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              print(document.reference);
              docIDs.add(document.reference.id);
            }));
  }

  @override
  void initState() {
    getDocId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.grey[200], // Set background color to very light grey
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.black, // Set arrow color to black
              onPressed: () {
                Navigator.pop(context); // Navigate back to previous page
              },
            ),
            SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                backgroundImage: profileImageUrl.isNotEmpty
                    ? NetworkImage(profileImageUrl)
                    : null,
                child: profileImageUrl.isEmpty
                    ? Icon(Icons.person, size: 50)
                    : null,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Username:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              username,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Email:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              user.email!,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return MapPage();
                }));
              },
              icon: Icon(Icons.map),
              label: Text('Go to Map'),
              style: ElevatedButton.styleFrom(
                primary: Colors.lightGreen, // Set button color to light green
                onPrimary: Colors.white, // Set text color to white
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ChatPage();
                }));
              },
              icon: Icon(Icons.chat),
              label: Text('Go to Chat'),
              style: ElevatedButton.styleFrom(
                primary: Colors.lightGreen, // Set button color to light green
                onPrimary: Colors.white, // Set text color to white
              ),
            ),
            Spacer(),
            // Align(
            //   alignment: Alignment.center,
            //   child: ElevatedButton(
            //     onPressed: () {
            //       // TODO: Implement logic to change username
            //     },
            //     child: Text('Change Username'),
            //     style: ElevatedButton.styleFrom(
            //       primary: Colors.lightGreen, // Set button color to light green
            //       onPrimary: Colors.white, // Set text color to white
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
