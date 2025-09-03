import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

// Make sure you have the necessary imports

class OfficerProfileCard extends StatelessWidget {
  final String officerName;
  final String designation;
  final String profileImage;
  final VoidCallback onLogout;

  const OfficerProfileCard({
    super.key,
    required this.officerName,
    required this.designation,
    required this.profileImage,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white, // Example color, replace with AppTheme if needed
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.blue, // Example color
                width: 2,
              ),
            ),
            child: ClipOval(
              child: Image.network(
                profileImage,
                width: 15.w,
                height: 15.w,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  officerName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black, // Example color
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  designation,
                  style: TextStyle(
                    color: Colors.grey, // Example color
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onLogout,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: Colors.red, // Example color
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.logout,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
