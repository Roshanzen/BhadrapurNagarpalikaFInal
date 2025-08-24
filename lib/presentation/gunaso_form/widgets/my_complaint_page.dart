import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MyComplaintsScreen extends StatelessWidget {
  const MyComplaintsScreen({Key? key}) : super(key: key);

  // Mock data for complaints
  final List<Map<String, dynamic>> complaints = const [
    {
      'id': 1,
      'title': 'सडक मर्मत',
      'description': 'मुख्य सडकमा खाल्डाखुल्डी भएको छ, मर्मत आवश्यक छ।',
      'date': '२०८१/०५/१५',
      'status': 'पेंडिंग',
    },
    {
      'id': 2,
      'title': 'प्रदूषण नियन्त्रण',
      'description': 'नजिकैको कारखानाबाट धुवाँ निस्किरहेको छ, नियन्त्रण आवश्यक छ।',
      'date': '२०८१/०५/१०',
      'status': 'सुनुवाई भइरहेको',
    },
    {
      'id': 3,
      'title': 'खानेपानी समस्या',
      'description': 'पानीको आपूर्ति नियमित छैन, समस्या समाधान आवश्यक छ।',
      'date': '२०८१/०५/०५',
      'status': 'समाधान भएको',
    },
    {
      'id': 4,
      'title': 'बिजुली समस्या',
      'description': 'बिजुली आउँदैन, नियमित रूपमा काटिन्छ।',
      'date': '२०८१/०५/०१',
      'status': 'पेंडिंग',
    },
    {
      'id': 5,
      'title': 'फोहोर व्यवस्थापन',
      'description': 'फोहोर उचाल्ने सेवा नियमित छैन, व्यवस्थापन आवश्यक छ।',
      'date': '२०८१/०४/२५',
      'status': 'सुनुवाई भइरहेको',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        title: Text(
          'आफ्नो गुनासो',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'तपाईंको गुनासोहरू',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: complaints.length,
              itemBuilder: (context, index) {
                final complaint = complaints[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 1.h),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                      child: Icon(
                        Icons.assignment,
                        color: theme.colorScheme.primary,
                        size: 5.w,
                      ),
                    ),
                    title: Text(
                      complaint['title'],
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          complaint['description'],
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Row(
                          children: [
                            Text(
                              complaint['date'],
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: complaint['status'] == 'पेंडिंग'
                                    ? Colors.orange.withOpacity(0.1)
                                    : complaint['status'] == 'सुनुवाई भइरहेको'
                                    ? Colors.blue.withOpacity(0.1)
                                    : Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                complaint['status'],
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: complaint['status'] == 'पेंडिंग'
                                      ? Colors.orange
                                      : complaint['status'] == 'सुनुवाई भइरहेको'
                                      ? Colors.blue
                                      : Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    onTap: () {
                      // Navigate to complaint details if needed
                      print('Tapped on complaint #${complaint['id']}');
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
