import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_export.dart';

class HelpBottomSheetWidget extends StatelessWidget {
  final bool isNepali;

  const HelpBottomSheetWidget({
    super.key,
    required this.isNepali,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> helpItems = [
      {
        "title": isNepali ? "कार्यालय (अधिकारी)" : "Karyalaya (Officer)",
        "description": isNepali
            ? "नगरपालिकाका अधिकारीहरूका लागि। गुनासो व्यवस्थापन र समाधान गर्न।"
            : "For municipal officers. To manage and resolve complaints.",
        "icon": "badge",
      },
      {
        "title": isNepali ? "जनता (नागरिक)" : "Janta (Citizen)",
        "description": isNepali
            ? "स्थानीय नागरिकहरूका लागि। गुनासो दर्ता र ट्र्याक गर्न।"
            : "For local citizens. To register and track complaints.",
        "icon": "people",
      },
      {
        "title": isNepali ? "दर्ता प्रक्रिया" : "Registration Process",
        "description": isNepali
            ? "अधिकारीहरूले प्रयोगकर्ता नाम र पासवर्ड प्रयोग गर्छन्। नागरिकहरूले Google/Facebook मार्फत लगइन गर्छन्।"
            : "Officers use username and password. Citizens login via Google/Facebook.",
        "icon": "how_to_reg",
      },
    ];

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            isNepali ? "सहायता र जानकारी" : "Help & Information",
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          ...helpItems.map((item) => Container(
            margin: EdgeInsets.only(bottom: 2.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  _getIconData(item["icon"]),
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 5.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["title"],
                        style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        item["description"],
                        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              ),
              child: Text(
                isNepali ? "बुझें" : "Got it",
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case "badge":
        return Icons.badge;
      case "people":
        return Icons.people;
      case "how_to_reg":
        return Icons.how_to_reg;
      default:
        return Icons.help_outline;
    }
  }
}