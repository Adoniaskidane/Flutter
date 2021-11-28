// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:bunamedia/Pages/homepage.dart';
import 'package:bunamedia/Pages/services/pref.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Stless WelcomPage With a continue button
class WelcomPage extends StatefulWidget {
  const WelcomPage({ Key? key }) : super(key: key);

  @override
  State<WelcomPage> createState() => _WelcomPageState();
}

class _WelcomPageState extends State<WelcomPage> {

  @override
  void initState(){
    // TODO: implement initState
    print('Welcome Page init');
    super.initState();
    //UserSharedpref();
  }

  void UserSharedpref() async{
    Userpreference _pref=Userpreference();
    final result=await _pref.getUserprefrerence();
    print(result);
    if(result!="NoData")
    {
      print("get Data");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>HomePage()));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800],
      body: SafeArea(
        child: Container(
        color: Colors.blue[800],
         child: Center(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
                Column(
                  children: [
                    Text('Welcome\n To BunaMedia',
                     textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Georgia',//'cursive',
                      ),
                     ),
                    SizedBox(height: 50,),
                    Text('UDC Students Social Media Platform.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.red
                      )
                    ),
                  ],
                ),
                SizedBox(height: 10,),

               Column(
                 children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: [
                       MaterialButton(
                         shape:RoundedRectangleBorder(
                           borderRadius: BorderRadius.all(
                             Radius.circular(15)
                           ),
                         ),
                        clipBehavior: Clip.hardEdge,
                         child: Text('SignIn',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Georgia'
                          ),
                         ),
                         color: Colors.black87,
                          height: 50,
                          minWidth: 100,
                          elevation: 1,
                         onPressed: (){
                           Navigator.pushReplacementNamed(context, '/SignIn');
                         },
                       ),
                       MaterialButton(
                        shape:RoundedRectangleBorder(
                           borderRadius: BorderRadius.all(
                             Radius.circular(15)
                           ),
                         ),
                         clipBehavior: Clip.hardEdge,
                         child: Text('Get Started',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Georgia'
                          ),
                         ),
                         color: Colors.black87,
                          height: 50,
                          minWidth: 100,
                          elevation: 1,
                         onPressed: (){
                           Navigator.pushReplacementNamed(context, '/SignIn');
                           Navigator.pushNamed(context, '/SignUp');
                         },
                       ),
                     ],
                   ),


                  SizedBox(height: 20,),
                  Text('Join your Community',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.red
                  )
                  ),
                 ],
               ),
             ],
           ),
           ),
         ),
      ),
    );    
  }
}


