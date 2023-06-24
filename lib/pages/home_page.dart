import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'profile_page.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  FilePickerResult? result;
  String? _fileName;
  PlatformFile? pickedfile;
  bool isLoadding = false;
  File? fileToDisplay;

  //Les files pour la caméra
  File? image;

  // TODO: Ajoutez les droits de gallery
  Future pickImage() async {
    try {
      //Appel l'image_picker, pick and image et appel la source
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      //Si il a réussi a sellectionner une image
      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  // TODO: Ajoutez les droits de camera
  Future pickCamera() async {
    try {
      //Appel l'image_picker, pick and image et appel la source
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      //Si il a réussi a sellectionner une image
      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void pickFile() async {
    try {
      setState(() {
        isLoadding = true;
      });

      //Resultat du FilePicker
      result = await FilePicker.platform.pickFiles(
        //Type de File en any donc n'importe quelle type
        type: FileType.any,
        //On autorise pas les multiples files
        allowMultiple: false,
      );

      if (result != null) {
        _fileName = result!.files.first.name;
        pickedfile = result!.files.first;
        fileToDisplay = File(pickedfile!.path.toString());

        print("File name $_fileName");
      }

      setState(() {
        isLoadding = false;
      });
    } catch (e) {
      print(e);
    }
  }

  //Tensor flow
  void sendImageToPython(File imageFile) async {
    final url = Uri.parse('https://loginplant.firebaseapp.com/ia.py');
    final request = http.MultipartRequest('POST', url);
    final bytes = await imageFile.readAsBytes();
    final multipartFile = http.MultipartFile.fromBytes('image', bytes,
        filename: imageFile.path.split('/').last);
    request.files.add(multipartFile);
    final response = await request.send();
    if (response.statusCode == 200) {
      final responseString = await response.stream.bytesToString();
      print(responseString);
      if (responseString == 'flower') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Flower Detected"),
              content: Text("The flower name is XYZ."),
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("No flower detected."),
            );
          },
        );
      }
    } else {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return ProfilePage();
                          },
                        ));
                      },
                      icon: Icon(
                        Icons.account_circle,
                        color: Colors
                            .lightGreen, // Change icon color to light green
                        size: 30, // Increase icon size
                      ),
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    child: IconButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                      },
                      icon: Icon(Icons.exit_to_app),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      color: image != null ? null : Colors.grey[200],
                      child: image != null
                          ? Image.file(
                              image!,
                              fit: BoxFit.cover,
                            )
                          : const Text(
                              "No Image selected",
                              style: TextStyle(color: Colors.grey),
                            ),
                    ),
                    if (image != null)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              image = null;
                            });
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    // TODO: Ajouter la fonctionalité d'ajout d'image
                                    pickImage();
                                  },
                                  icon: Icon(
                                    Icons.add_a_photo,
                                    size: 30,
                                  ),
                                  color: Colors.green,
                                ),
                                IconButton(
                                  onPressed: () {
                                    // TODO: Ajouter la fonctionalité de prise de photo
                                    pickCamera();
                                  },
                                  icon: Icon(
                                    Icons.camera_alt,
                                    size: 30,
                                  ),
                                  color: Colors.green,
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: ElevatedButton(
                                onPressed: () {
                                  // TODO: Ajouter la fonctionalité de prise de photo
                                  if (image != null) {
                                    sendImageToPython(image!);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  "Recognize",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
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
            ],
          ),
        ),
      ),
    );
  }
}
