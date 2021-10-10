// ignore_for_file: prefer_const_constructors, avoid_print
import 'package:bunamedia/Pages/services/auth.dart';
import 'package:bunamedia/Pages/services/pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class SignInPage extends StatefulWidget {
  const SignInPage({ Key? key }) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  UserAuthentication _authentication=UserAuthentication(FirebaseAuth.instance);
  final GlobalKey<FormState> _key=GlobalKey<FormState>();
  validator _isvalid=validator();
  
  TextEditingController _email=TextEditingController();
  TextEditingController _password=TextEditingController();
  @override
  void initState(){
    super.initState();
    print("Hello World");
  }

  void keepLogged(String value)async{
    Userpreference pref=Userpreference();
    final result=await pref.setUserprefrerence(value);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Center(
            child: Form(
              key:_key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width:MediaQuery.of(context).size.width*0.7,
                    child: TextFormField(
                      controller: _email,
                      validator:_isvalid.emailValidator ,
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
                      validator: _isvalid.passValidator,
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
                      if(_key.currentState!.validate()){
                      final result=await _authentication.SignIn(_email.text,_password.text);
                      if(result)
                      {
                        print("LoggedIn successfuly");
                        keepLogged(_email.text);
                        Navigator.pushReplacementNamed(context,'/home',arguments: {'logged': false});
                      }
                      else{
                        print('Failed to LogIn successfuly');
                      }
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
            ),
          )
    );
  }
}