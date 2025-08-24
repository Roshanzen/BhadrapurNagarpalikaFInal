import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CompletedComplaintsPage extends StatefulWidget {
  const CompletedComplaintsPage({Key? key}) : super(key: key);

  @override
  State<CompletedComplaintsPage> createState() =>
      _CompletedComplaintsPageState();
}

class _CompletedComplaintsPageState extends State<CompletedComplaintsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('सम्पूर्ण गुनासो'),
      ),
      body: Center(
        child: Text(
          'Completed Complaints Page',
          style: TextStyle(fontSize: 16.sp),
        ),
      ),
    );
  }
}
