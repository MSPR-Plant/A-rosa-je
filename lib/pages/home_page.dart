import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
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
  Future pickImage() async{
    try{
      //Appel l'image_picker, pick and image et appel la source
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      //Si il a réussi a sellectionner une image
      if(image == null) return;

      final imageTemp = File(image.path);

      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException catch (e){
      print(e);
    }
  }


  // TODO: Ajoutez les droits de camera
  Future pickCamera() async{
    try{
      //Appel l'image_picker, pick and image et appel la source
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      //Si il a réussi a sellectionner une image
      if(image == null) return;

      final imageTemp = File(image.path);

      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException catch (e){
      print(e);
    }
  }

  void pickFile() async{
    try{
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

      if(result != null){
        _fileName = result!.files.first.name;
        pickedfile = result!.files.first;
        fileToDisplay = File(pickedfile!.path.toString());

        print("File name $_fileName");
      }


      setState(() {
        isLoadding = false;
      });
    }catch (e) {
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Signed in as ' + user.email!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 200,),
                          SizedBox(
                            height: 80,
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Ajouter la fonctionalité d'ajout d'image
                                pickImage();
                              },
                              icon: Icon(Icons.add),
                              label: Text('Upload your Image'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          if (!kIsWeb) // TODO: Check if app is not running on web
                            SizedBox(height: 20),
                          if (!kIsWeb)
                            SizedBox(
                              height: 80,
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // TODO: Ajouter la fonctionalité de prise de photo
                                  
                                  pickCamera();
                                  
                                },
                                icon: Icon(Icons.add),
                                label: Text('Take a photo of your plant'),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                          
                            SizedBox(
                              height: 80,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  // TODO: Ajouter la fonctionalité de prise de photo
            
                                  sendImageToPython(fileToDisplay!);
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ), child: Text("Reconize",
                                style: TextStyle(fontSize: 20,)),
                              ),
                            ),
                        ],
                      ),
                    ),
                    
                    /*if(pickedfile !=null)
                      SizedBox(
                        height: 300,
                        width: 300,
                        child: Image.file(fileToDisplay!),
                        
                        
                      )else(Text("No Image Selected")),*/
                     image != null ? Image.file(image!): const Text("No Image selected"),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                          },
                          child: Text('Sign out'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
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
    );
  }
}
