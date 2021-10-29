// ignore_for_file: prefer_const_constructors
import 'package:bunamedia/Pages/services/pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadScreen extends StatefulWidget {
  const LoadScreen({ Key? key }) : super(key: key);

  @override
  _LoadScreenState createState() => _LoadScreenState();
}

class _LoadScreenState extends State<LoadScreen> {
  

  void UserSharedpref() async{
    Userpreference _pref=Userpreference();
    final result=await _pref.getUserprefrerence();
    Future.delayed(Duration(seconds: 2), () {
    print(result);
    if(result!="NoData")
    {
      print("get Data");
      Navigator.popAndPushNamed(context,'/home',arguments:{'Logged':true,'Username':result});
    }
    else{
      Navigator.popAndPushNamed(context,'/welcome');
    }
    });
    
  }

  @override
  void initState(){
    super.initState();
    print("init LoadScreen");
    UserSharedpref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: SpinKitFadingFour(
        color: Colors.white,
        size: 50.0,
      ),
    );
  }
}