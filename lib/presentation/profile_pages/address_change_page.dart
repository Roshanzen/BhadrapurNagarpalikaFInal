import 'package:flutter/material.dart';

class AddressChangePage extends StatelessWidget {
  const AddressChangePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Address Change'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Address Change Page'),
      ),
    );
  }
}