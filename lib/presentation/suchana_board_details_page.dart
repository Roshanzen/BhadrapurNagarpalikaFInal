import 'package:flutter/material.dart';

class SuchanaBoardDetailsPage extends StatelessWidget {
  final Map<String, dynamic> notice;
  
  const SuchanaBoardDetailsPage({super.key, required this.notice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(notice['title'] ?? 'Notice Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notice['title'] ?? 'No Title',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              notice['description'] ?? 'No Description',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Published: ${notice['date'] ?? 'Unknown Date'}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}