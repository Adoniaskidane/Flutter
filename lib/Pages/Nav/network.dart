// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Network extends StatefulWidget {
  const Network({ Key? key }) : super(key: key);

  @override
  _NetworkState createState() => _NetworkState();
}

class _NetworkState extends State<Network> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Networking'),), 
    );
  }
}