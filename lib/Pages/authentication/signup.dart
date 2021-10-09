// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bunamedia/Pages/services/auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({ Key? key }) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  UserAuthentication _authentication=UserAuthentication(FirebaseAuth.instance);
  final GlobalKey<FormState>_formkey= GlobalKey<FormState>();
  final validator _isvalid=validator();

  TextEditingController _username=TextEditingController();
  TextEditingController _Firstname=TextEditingController();
  TextEditingController _Lastname=TextEditingController();
  TextEditingController _email=TextEditingController();
  TextEditingController _password=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width*0.7,
            child: Form(
              key:_formkey,
              child: ListView(
                padding:EdgeInsets.fromLTRB(0, 70,0,0),
                children: [
                      Container(
                        width:MediaQuery.of(context).size.width*0.7,
                        child: TextFormField(
                          controller: _username,
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
                          controller: _Firstname,
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
                          controller: _Lastname,
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
                          validator:_isvalid.emailValidator ,
                          controller: _email,
                          decoration: InputDecoration(
                            hintText: 'someonewith@udc.com',
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
                          validator: _isvalid.passValidator,
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
            
                  Container(
                    color: Colors.white,
                    child: ElevatedButton(
                      
                      onPressed: ()async{
                        print(_email.text+" = "+_password.text);
                        if(_formkey.currentState!.validate()){
                        final result=await _authentication.SignUp(_email.text, _password.text);
                        if(result){
                          print('Successfuly SignUp');
                          Navigator.pop(context);
                        }else{
                          print('Failed to SignUp');
                        }
 
                        }
                       
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
      ),
    );
  }
}