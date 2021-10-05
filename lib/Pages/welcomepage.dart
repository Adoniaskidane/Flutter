// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'package:bunamedia/Pages/signin.dart';
import 'package:flutter/material.dart';

class WelcomPage extends StatelessWidget {
  const WelcomPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
     child: Center(
       child: ElevatedButton(
         onPressed: (){
          Navigator.pop(context);
          Navigator.push(context,MaterialPageRoute(builder: (context) =>const SignInPage()));
         },
         child: Text("LogIn")
         ),
       ),
     );
  }
}