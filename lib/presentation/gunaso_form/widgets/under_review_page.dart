import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class UnderReviewPage extends StatefulWidget {
  const UnderReviewPage({Key? key}) : super(key: key);

  @override
  State<UnderReviewPage> createState() => _UnderReviewPageState();
}

class _UnderReviewPageState extends State<UnderReviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('सुनवाई भएको गुनासो'),
      ),
      body: Center(
        child: Text(
          'Under Review Page',
          style: TextStyle(fontSize: 16.sp),
        ),
      ),
    );
  }
}
