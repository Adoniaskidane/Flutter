// ignore_for_file: prefer_const_constructors, avoid_print
import 'package:bunamedia/Pages/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({ Key? key }) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}


class _SignInPageState extends State<SignInPage> {
  UserAuthentication _authentication=UserAuthentication(FirebaseAuth.instance);

  TextEditingController _email=TextEditingController();
  TextEditingController _password=TextEditingController();
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
                    controller: _email,
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
                    controller: _password,
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
                  onPressed:() async{
                    final result=await _authentication.SignIn(_email.text,_password.text);
                    if(result)
                    {
                      print("LoggedIn successfuly");
                      Navigator.pushReplacementNamed(context,'/home');
                    }
                    else{
                      print('Failed to LogIn successfuly');
                    }
                   
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