// ignore_for_file: prefer_const_constructors
import 'package:bunamedia/Pages/services/pref.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {

  String CurrentUser="";
  void keepLoggedOut()async{
    Userpreference pref=Userpreference();
    await pref.removeUserpreference();
  }
  void getCurrentUser() async{
    Userpreference pref=Userpreference();
    final result= await pref.getUserprefrerence();
    print(result);
    CurrentUser=result;
    setState(() {
      print("SetState");
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("HomePage init");
    getCurrentUser();
    print("HomePage init Done");

  }
  @override
  Widget build(BuildContext context) {
    print(ModalRoute.of(context)?.settings.arguments);
    return Scaffold(
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("HomePage of $CurrentUser"),
            ElevatedButton(
              onPressed: (){
                keepLoggedOut();
                Navigator.popAndPushNamed(context,'/');
              },
              child:Text("SignOut") ,
            )
          ],
        ),
      ),
      
    );
  }
}