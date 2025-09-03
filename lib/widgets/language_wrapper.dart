import 'package:flutter/material.dart';

class LanguageWrapper extends StatelessWidget {
  final Widget child;
  
  const LanguageWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // This is a basic language wrapper that simply returns the child widget
    // You can expand this to include language-specific functionality
    return child;
  }
}