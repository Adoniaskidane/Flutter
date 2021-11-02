// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        //color: Colors.blue[900],

        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:  [Colors.purple, Colors.lightBlue],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration:BoxDecoration(
                  color:Colors.white,
                  borderRadius:BorderRadius.circular(100)
                ),
                  width: 200,

                  child: const Image(
                    image: AssetImage('assets/images/b.png'),

                  )),
              Text(
                'BunaMedia',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
              Text(
                'SignUp or LogIn to continue',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.brown[900],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('SignUp'),
                  ),
                  const SizedBox(
                    width: 100,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("LogIn "),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
