// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors
import 'package:flutter/material.dart';

//Stless WelcomPage With a continue button
class WelcomPage extends StatelessWidget {
  const WelcomPage({ Key? key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
       child: Center(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             ElevatedButton(
               onPressed: (){
                Navigator.pushReplacementNamed(context, '/SignIn');
               },
               child: Text("Continue To SignIn or LogIn")
               ),
           ],
         ),
         ),
       ),
    );
  }
}