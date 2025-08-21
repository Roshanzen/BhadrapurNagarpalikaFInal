import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AnalyticsWidget extends StatelessWidget {
  final Map<String, dynamic> notice;

  const AnalyticsWidget({
    super.key,
    required this.notice,
  });

  // Mock analytics data
  List<Map<String, dynamic>> get _analyticsData => [
    {
      'icon': 'visibility',
      'label': 'हेरिएको',
      'value': notice['viewCount'].toString(),
      'color': AppTheme.lightTheme.colorScheme.primary,
    },
    {
      'icon': 'share',
      'label': 'सेयर गरिएको',
      'value': '12', // Mock data
      'color': AppTheme.lightTheme.colorScheme.secondary,
    },
    {
      'icon': 'thumb_up',
      'label': 'मन पराइएको',
      'value': '45', // Mock data
      'color': AppTheme.successLight,
    },
    {
      'icon': 'comment',
      'label': 'टिप्पणी',
      'value': '8', // Mock data
      'color': AppTheme.warningLight,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CustomIconWidget(
                iconName: 'analytics',
                size: 24,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              SizedBox(width: 2.w),
              Text(
                'सूचना विश्लेषण',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
              const Spacer(),
              Text(
                'प्रकाशित: ${notice['publicationDate']}',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Analytics Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 2.5,
            ),
            itemCount: _analyticsData.length,
            itemBuilder: (context, index) {
              final item = _analyticsData[index];

              return Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: (item['color'] as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: (item['color'] as Color).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: item['color'] as Color,
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: item['icon'] as String,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item['value'] as String,
                            style: AppTheme.lightTheme.textTheme.titleLarge
                                ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: item['color'] as Color,
                            ),
                          ),
                          Text(
                            item['label'] as String,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          SizedBox(height: 3.h),

          // Performance Indicator
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'trending_up',
                      size: 20,
                      color: AppTheme.successLight,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'सूचनाको प्रदर्शन',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.successLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'राम्रो',
                        style:
                        AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  'यो सूचना अन्य सूचनाको तुलनामा धेरै हेरिएको छ र राम्रो प्रतिक्रिया पाएको छ।',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // View More Details Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                // Show detailed analytics
                _showDetailedAnalytics(context);
              },
              icon: CustomIconWidget(
                iconName: 'bar_chart',
                size: 20,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              label: const Text('विस्तृत विश्लेषण हेर्नुहोस्'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDetailedAnalytics(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle Bar
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.only(top: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'bar_chart',
                    size: 24,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'विस्तृत विश्लेषण',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      size: 24,
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Time-based Analytics
                    _buildAnalyticsSection(
                      'समय अनुसार हेराइ',
                      [
                        {'period': 'आज', 'views': '45'},
                        {'period': 'हिजो', 'views': '32'},
                        {'period': 'यो हप्ता', 'views': '245'},
                        {'period': 'यो महिना', 'views': '892'},
                      ],
                    ),

                    SizedBox(height: 3.h),

                    // Ward-wise Analytics
                    _buildAnalyticsSection(
                      'वडा अनुसार हेराइ',
                      [
                        {'period': 'वडा १', 'views': '48'},
                        {'period': 'वडा २', 'views': '35'},
                        {'period': 'वडा ३', 'views': '52'},
                        {'period': 'वडा ४', 'views': '28'},
                        {'period': 'अन्य', 'views': '82'},
                      ],
                    ),

                    SizedBox(height: 3.h),

                    // Device Analytics
                    _buildAnalyticsSection(
                      'उपकरण अनुसार हेराइ',
                      [
                        {'period': 'मोबाइल', 'views': '198'},
                        {'period': 'ट्याब्लेट', 'views': '32'},
                        {'period': 'डेस्कटप', 'views': '15'},
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsSection(String title, List<Map<String, String>> data) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 2.h),
          ...data
              .map((item) => Padding(
            padding: EdgeInsets.only(bottom: 1.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item['period']!,
                    style: AppTheme.lightTheme.textTheme.bodyMedium
                        ?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item['views']!,
                    style: AppTheme.lightTheme.textTheme.labelMedium
                        ?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ))
              .toList(),
        ],
      ),
    );
  }
}
