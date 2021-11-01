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
    if(res){
      Navigator.pop(context);
    }
    isverify=res;
    print(email);
    print('The result of isverify $res');

  }
  @override
  void initState() {
    // TODO: implement initState
    //checkverify();
    super.initState();
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.blue[900],
      body:Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            ElevatedButton(
              onPressed: ()async{
                isverify=await _authentication.checkVerifyStatus();
                if(isverify){
                  setState(() {
                    print('User verfied');
                    Navigator.pop(context);
                  });
                }
              },
              child: Text('Press here'))
          ],
        ) ,)
      ,
      /*body:FutureBuilder(
        future: checkverify(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(child:Column(
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
                Text("congratulations your Email is Verfied.",style: TextStyle(color: Colors.white,),),
                ElevatedButton(onPressed: (){
                  Navigator.pop(context); 
                }, child: Text('Press to Continue'))
              ],
            ));
          } else {
            // We can show the loading view until the data comes back.
            debugPrint('Step 1, build loading widget');
            return Center(child: CircularProgressIndicator());
          }
        },
      )
      */
      /*body: StreamBuilder(
        initialData:'Working',
        stream: _authentication.streamVerifyStatsu(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.hasData==false?
              CircularProgressIndicator():
              Center(child:Column(
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
                Text("congratulations your Email is Verfied.",style: TextStyle(color: Colors.white,),),
                ElevatedButton(onPressed: (){
                  Navigator.pop(context); 
                }, child: Text('Press to Continue'))
              ],
            ));
          } else {
            // We can show the loading view until the data comes back.
            debugPrint('Step 1, build loading widget');
            return Center(child: CircularProgressIndicator());
          }
        },
      ),*/
      
      /*FutureBuilder(
        future: checkverify(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(child:Column(
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
                Text("congratulations your Email is Verfied.",style: TextStyle(color: Colors.white,),),
                ElevatedButton(onPressed: (){
                  Navigator.pop(context); 
                }, child: Text('Press to Continue'))
              ],
            ));
          } else {
            // We can show the loading view until the data comes back.
            debugPrint('Step 1, build loading widget');
            return Center(child: CircularProgressIndicator());
          }
        },
      )*/
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