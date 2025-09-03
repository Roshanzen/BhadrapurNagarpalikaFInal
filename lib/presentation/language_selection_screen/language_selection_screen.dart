import 'package:flutter/material.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Language'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Language Selection Screen'),
      ),
    );
  }
}