// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
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
    Future.delayed(Duration(seconds: 3), () {
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
      body:Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/bg.png'),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Center(
                child: Image(image: AssetImage('assets/images/b.png'),)
              ),
            ),
            SpinKitWave(
              color: Colors.blue[900],
              size: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}