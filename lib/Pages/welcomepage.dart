// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors
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
      Navigator.popAndPushNamed(context,'/home',arguments:{'Logged':true,'Username':result});
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
       child: Center(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             ElevatedButton(
               onPressed: (){
                Navigator.pushReplacementNamed(context, '/SignIn');

               },
               child: Text("Continue To SignIn or LogIn")
               ),
           ],
         ),
         ),
       ),
    );    
  }
}



class CustomNamedPageTransition extends PageRouteBuilder {
  CustomNamedPageTransition(
    GlobalKey materialAppKey,
    String routeName, {
    Object? arguments,
  }) : super(
          settings: RouteSettings(
            arguments: arguments,
            name: routeName,
          ),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            assert(materialAppKey.currentWidget != null);
            assert(materialAppKey.currentWidget is MaterialApp);
            var mtapp = materialAppKey.currentWidget as MaterialApp;
            var routes = mtapp.routes;
            assert(routes!.containsKey(routeName));
            return routes![routeName]!(context);
          },
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
          transitionDuration: Duration(seconds: 1),
        );
}