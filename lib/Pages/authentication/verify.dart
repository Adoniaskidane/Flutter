// ignore_for_file: prefer_const_constructors

import 'package:bunamedia/Pages/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyUser extends StatefulWidget {
  
  final UserAuthentication authentication;
  final String email;
  const VerifyUser({ Key? key,required this.authentication,required this.email} ) : super(key: key);

  @override
  _VerifyUserState createState() => _VerifyUserState(authentication,email);
}

class _VerifyUserState extends State<VerifyUser> {

  bool isverify=false;
  final UserAuthentication authentication;
  final String email;
  _VerifyUserState(this.authentication,this.email);

  final UserAuthentication _authentication=UserAuthentication(FirebaseAuth.instance);
  final TextEditingController _data=TextEditingController();

  Future<void> checkverify()async{
    final res= await authentication.checkVerifyStatus();
    isverify=res;
    print(email);
    print('The result of isverify $res');
    setState(() {
      
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    checkverify();
    super.initState();
   
  }

  @override
  Widget build(BuildContext context) {
    return isverify==false?Scaffold(
      body:Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        ElevatedButton(
            onPressed:()async{
              await checkverify();
              if(isverify==true)
              {
                Navigator.pop(context);
              }
            },
            child:Text('Verified') 
          )
      ],
    )):
    Scaffold(
      body: 
          Center(child: Text('Success')),
    );
  }
}

/*

Scaffold(
      backgroundColor: Colors.blue[900],
      appBar: AppBar(
        title: Text('Verify Email'),
      ),
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
                    decoration:BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)
                      ),
                          width:MediaQuery.of(context).size.width*0.7,
                          child: TextFormField(
                            controller:_data,
                            decoration: InputDecoration(
                              hintText: 'Sent code',
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
                                final result=await _authentication.verifyEmail(email,_data.text);
                                if(result)
                                {
                                  Navigator.pop(context);
                                }
                                //get the value of the result and call veriyEmail function which set the verification true
                                //Also pop the page and call isverify to make sure it is verifid if not complain
                                //
                              },
                              child: Text('Submit'),
                      ),
                    ),
          ],
        ),
      ), 
    );
*/