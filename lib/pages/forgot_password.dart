import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key ? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  //controllers
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose(); 
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
        context: context, 
        builder: (context){
          return AlertDialog(
            content: Text('You successfully reseted your password ! Check your email'),
        );
      });    
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
        context: context, 
        builder: (context){
          return AlertDialog(
            content: Text(e.message.toString()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text("Enter Your Email and you'll receive a password reseting process",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
              ),
            ),

            SizedBox(height: 30,),

            //Email
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 124, 124, 124),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: Offset(2,2),
                        ),
                      ] 
                      
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 30,),
                //Button
                MaterialButton(
                  onPressed: passwordReset,
                  child: Text(
                    'Reset PassWord',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.green,
                ),
          ],
        ),
      ),
    );
  }
}