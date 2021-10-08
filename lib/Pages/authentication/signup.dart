// ignore_for_file: prefer_const_constructors

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
      body: SafeArea(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width*0.7,
            child: ListView(
              padding:EdgeInsets.fromLTRB(0, 70,0,0),
              children: [
                    Container(
                      width:MediaQuery.of(context).size.width*0.7,
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Username',
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
                    SizedBox(height: 10),
                    Container(
                      width:MediaQuery.of(context).size.width*0.7,
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Firstname',
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
                          hintText: 'Lastname',
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
                Container(
                  color: Colors.white,
                  child: ElevatedButton(
                    
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Text("SignUp here"),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  color: Colors.white,
                  child: ElevatedButton(
                    
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Text("LogIn"),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}