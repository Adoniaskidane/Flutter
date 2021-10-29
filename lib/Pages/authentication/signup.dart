// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'dart:math';
import 'package:bunamedia/Pages/authentication/verify.dart';
import 'package:bunamedia/Pages/services/db.dart';
import 'package:bunamedia/Pages/services/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bunamedia/Pages/services/auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({ Key? key }) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final UserAuthentication _authentication=UserAuthentication(FirebaseAuth.instance);
  final GlobalKey<FormState>_formkey= GlobalKey<FormState>();
  final validator _isvalid=validator();

  final TextEditingController _username=TextEditingController();
  final TextEditingController _Firstname=TextEditingController();
  final TextEditingController _Lastname=TextEditingController();
  final TextEditingController _email=TextEditingController();
  final TextEditingController _password=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
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
                      decoration:BoxDecoration(
                        borderRadius: BorderRadius.circular(15)
                      ),
                        width:MediaQuery.of(context).size.width*0.7,
                        child: TextFormField(
                          controller: _username,
                          decoration: InputDecoration(
                            hintText: 'Username',
                            fillColor: Colors.white,
                            filled: true,
                            errorStyle:TextStyle(color: Colors.orange, fontSize: 15) ,
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
                     decoration:BoxDecoration(
                        borderRadius: BorderRadius.circular(15)
                      ),
                        width:MediaQuery.of(context).size.width*0.7,
                        child: TextFormField(
                          controller: _Firstname,
                          decoration: InputDecoration(
                            hintText: 'Firstname',
                            fillColor: Colors.white,
                            filled: true,
                            errorStyle:TextStyle(color: Colors.orange, fontSize: 15) ,                            
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
                     decoration:BoxDecoration(
                        borderRadius: BorderRadius.circular(15)
                      ),
                        width:MediaQuery.of(context).size.width*0.7,
                        child: TextFormField(
                          controller: _Lastname,
                          decoration: InputDecoration(
                            hintText: 'Lastname',
                            fillColor: Colors.white,
                            filled: true,
                            errorStyle:TextStyle(color: Colors.orange, fontSize: 15) ,                          
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
                    decoration:BoxDecoration(
                        borderRadius: BorderRadius.circular(15)
                      ),
                        width:MediaQuery.of(context).size.width*0.7,
                        child: TextFormField(
                          validator:_isvalid.emailValidator ,
                          controller: _email,
                          decoration: InputDecoration(
                            hintText: 'someonewith@udc.com',
                            fillColor: Colors.white,
                            filled: true,
                            errorStyle:TextStyle(color: Colors.orange, fontSize: 15) ,                          
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
                    decoration:BoxDecoration(
                        borderRadius: BorderRadius.circular(15)
                      ),
                        width:MediaQuery.of(context).size.width*0.7,
                        child: TextFormField(
                          validator: _isvalid.passValidator,
                          controller: _password,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            fillColor: Colors.white,
                            filled: true,
                            errorStyle:TextStyle(color: Colors.orange, fontSize: 15) ,                         
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
                    child: ElevatedButton(
                      onPressed: ()async{
                        if(_formkey.currentState!.validate())
                        {
                          final result=await _authentication.SignUp(_email.text, _password.text);
                          if(result){
                          print('Successfuly SignUp');
                          await _authentication.sendEmail(_email.text);
                          //_authentication.VerifyEmail(_email.text);
                          //await Navigator.pushNamed(context,'/verify',arguments: {'Email':_email.text});
                          await Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => VerifyUser(authentication: _authentication,email: _email.text,)));
                          final useruid= await _authentication.CurrentUid();
                          Database db=Database(uid:useruid );
                          db.InsertUserData(_username.text,_Firstname.text,_Lastname.text,_email.text);
                          print('Inserted on the DB');
                          Navigator.pop(context);}
                        }else
                        { 
                          print('Failed to SignUp');
                        }
                        

                      },
                        //Check Validation
                        //_formkey.currentState!.validate()
                        /*
                        if(true){
                          final sentcode=await _authentication.SendverifyingCode(_email.text);
                          if(sentcode)
                          {
                             await Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => VerifyUser(email:_email.text,)));
                            final isverified=await _authentication.isEmailverified(_email.text);
                            if(isverified){
                              final result=await _authentication.SignUp(_email.text, _password.text);
                              await _authentication.sendEmail(_email.text);

                              if(result){
                                 print('Successfuly SignUp');
                                final useruid= await _authentication.CurrentUid();
                                Database db=Database(uid:useruid );
                                db.InsertUserData(_username.text,_Firstname.text,_Lastname.text,_email.text);
                                print('Inserted on the DB');
                                try{
                                  Navigator.pop(context);
                                }on FirebaseException catch(e){
                                  print(e);
                                }
                                
                              }else{
                                  print('Failed to SignUp');
                              }
                            }else{

                            }
                        }
                        }else{
                          print('unable to validate');
                          
                        }*/




                        

                        /*
                        print(_email.text+" = "+_password.text);

                        //Check Validation
                        if(_formkey.currentState!.validate()){


                        
                        final result=await _authentication.SignUp(_email.text, _password.text);
                        if(result){
                          print('Successfuly SignUp');
                          _authentication.VerifyEmail(_email.text);
                          await Navigator.pushNamed(context,'/verify',arguments: {'Email':_email.text});
                          final useruid= await _authentication.CurrentUid();
                          Database db=Database(uid:useruid );
                          db.InsertUserData(_username.text,_Firstname.text,_Lastname.text,_email.text);
                          print('Inserted on the DB');
                          Navigator.pop(context);
                        }
                        else{ 
                        print(
                         'Failed to SignUp');
                        }
 
                        }*/
                       
                      
                      child: Text("SignUp here"),
                    ),
                  ),
            
                  SizedBox(height: 10,),
            
                  Container(
                    
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