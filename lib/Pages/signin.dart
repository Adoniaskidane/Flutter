import 'package:bunamedia/Pages/homepage.dart';
import 'package:bunamedia/Pages/welcomepage.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({ Key? key }) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}


class _SignInPageState extends State<SignInPage> {

  @override
  void initState(){
    super.initState();
    print("Hello World");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:Center(
          child: Column(
            children: [
              Text("SignIn page"),
              ElevatedButton(
                onPressed:() {
                  Navigator.pop(context);
                  Navigator.push(context,MaterialPageRoute(builder: (context) =>const HomePage()));
                },
                child: Text("Login"),
              )
            ],
          ),
        )
      ), 
    );
  }
}