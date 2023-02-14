import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Register extends StatefulWidget {
  final VoidCallback showLoginPage;
  const Register({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  //controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  //disposing of the textfield for memory
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose(); 
  }

  //Sign up method
  Future signUp() async{
    
    try {
      if (passwordIsConfirmed()) {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _emailController.text.trim(), 
      password: _passwordController.text.trim()
      );
      showDialog(context: context, builder: (context){
        return AlertDialog(
          content: Text('Congratulation ! Your account was created.'),
        );
      });
    }
    } on FirebaseAuthException catch (e) {
      showDialog(context: context, builder: (context){
        return AlertDialog(
          content: Text(e.message.toString()),
        );
      });
    } 
  }

  bool passwordIsConfirmed() {
    if (_passwordController.text.trim() == _confirmPasswordController.text.trim()) {
      return true;
    }else {
      return false;
    }
  }


  @override
  Widget build(BuildContext context) {
  return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
            
                  children: [
                  
                  //Logo
                  Text('KnowYourPlant',
                  style: TextStyle(
                    //GoogleFonts.bebasNeue(fontSize:52)
                    fontWeight: FontWeight.bold,
                    fontSize: 48,
                    color: Colors.green,
                  ),),
            
                  SizedBox(height: 40),
                  //Logo
                  Text('Register to have your Account',
                  style: TextStyle(
                    color: Color.fromARGB(255, 129, 129, 129),
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                  ),
            
                  SizedBox(height: 30),
                  //Email
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                          color: Color.fromARGB(255, 161, 161, 161),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(1,1),
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
                    
                  SizedBox(height: 20),
                  //Password
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                          color: Color.fromARGB(255, 161, 161, 161),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(1,1),
                          ),
                        ] 
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                    
                  SizedBox(height: 20),

                  //Confirm Password
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                          color: Color.fromARGB(255, 161, 161, 161),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(1,1),
                          ),
                        ] 
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Confirm Password',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                    
                  SizedBox(height: 45),
                  //Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: GestureDetector(
                      onTap: signUp,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 161, 161, 161),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(1,1),
                            ),
                          ] 
                        ),
                        child: Center(
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            )
                          ),
                      ),
                    ),
                  ),
            
                  SizedBox(height: 45),
            
                  Text('Or Sign up with',
                  style: TextStyle(
                    color: Color.fromARGB(255, 129, 129, 129),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  ),
            
                  SizedBox(height: 20),
                  //Icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
          
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 161, 161, 161),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(1,1),
                        ),
                      ] 
                        ),
                      child: 
                      Icon(FontAwesomeIcons.google,
                      size: 50,
                      //color: Colors.red[600],
                      ),
                      ),
          
                    SizedBox(width: 45),
          
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 161, 161, 161),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(1,1),
                        ),
                      ] 
                        ),
                      child: 
                      Icon(FontAwesomeIcons.apple,
                      size: 50,
                      ),
                      ),
                  ],
                ),
            
                  //Change page
                  SizedBox(height: 45),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: widget.showLoginPage,
                            child: Text(
                              'Sign in',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 24,
                                fontWeight: FontWeight.bold
                              ),
                              ),
                          ),
                        ],
                      ),
            
                      SizedBox(width: 60),
            
                      Column(
                        children: [
                          GestureDetector(
                            
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold
                              ),
                              ),
                          ),
                        ],
                      ),
                    ],
                  ),
            
            
              ]),
            ),
          ),
        ),
      );
  }
}