import 'package:flutter/material.dart';

class MyComplaintPage extends StatefulWidget {
  const MyComplaintPage({Key? key}) : super(key: key);

  @override
  State<MyComplaintPage> createState() => _MyComplaintPageState();
}

class _MyComplaintPageState extends State<MyComplaintPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Complaints')),
      body: Center(child: Text('My Complaints Page')),
    );
  }
}
