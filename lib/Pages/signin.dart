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
        body:Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("SignIn page"),
                ElevatedButton(
                  onPressed:() {
                    //Navigator.pop(context);
                    //Navigator.push(context,MaterialPageRoute(builder: (context) =>const HomePage()));
                    Navigator.pushReplacementNamed(context,'/home');
                  },
                  child: Text("Login"),
                ),
                Text("You Don't Have an account"),
                ElevatedButton(
                  onPressed: (){
                    Navigator.pushNamed(context, '/SignUp');
                  },
                  child: Text('SignUp'),
                ),
              ],
            ),
          )
    );
  }
}