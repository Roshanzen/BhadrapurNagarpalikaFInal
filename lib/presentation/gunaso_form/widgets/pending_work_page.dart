import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PendingWorkPage extends StatefulWidget {
  const PendingWorkPage({Key? key}) : super(key: key);

  @override
  State<PendingWorkPage> createState() => _PendingWorkPageState();
}

class _PendingWorkPageState extends State<PendingWorkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('काम भैरहेको गुनासो'),
      ),
      body: Center(
        child: Text(
          'Pending Work Page',
          style: TextStyle(fontSize: 16.sp),
        ),
      ),
    );
  }
}
