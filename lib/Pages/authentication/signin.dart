// ignore_for_file: prefer_const_constructors, avoid_print

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
                Container(
                  width:MediaQuery.of(context).size.width*0.7,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'someone@gmail.com',
                      border:OutlineInputBorder(
                        borderSide: BorderSide(width: 3,color: Colors.orange),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder:OutlineInputBorder(
                        borderSide: BorderSide(width: 3,color: Colors.orange),
                        borderRadius: BorderRadius.circular(15),
                      )

                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  width:MediaQuery.of(context).size.width*0.7,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Password',
                      border:OutlineInputBorder(
                        borderSide: BorderSide(width: 3,color: Colors.orange),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder:OutlineInputBorder(
                        borderSide: BorderSide(width: 3,color: Colors.orange),
                        borderRadius: BorderRadius.circular(15),
                      )

                    ),
                  ),
                ),
                SizedBox(height: 10,),
                ElevatedButton(
                  onPressed:() {
                    Navigator.pushReplacementNamed(context,'/home');
                  },
                  child: Text("Login"),
                ),
                Text("You Don't Have an account"),
                TextButton(
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