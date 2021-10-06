import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({ Key? key }) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: ElevatedButton(
            
            onPressed: (){
              Navigator.pop(context);
            },
            child: Text("SignUp here"),
          ),
        ),
      ),
    );
  }
}