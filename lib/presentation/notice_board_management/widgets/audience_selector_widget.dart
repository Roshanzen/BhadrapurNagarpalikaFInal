import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AudienceSelectorWidget extends StatefulWidget {
  final String selectedAudience;
  final int? selectedWard;
  final Function(String audience, int? ward) onChanged;

  const AudienceSelectorWidget({
    super.key,
    required this.selectedAudience,
    required this.selectedWard,
    required this.onChanged,
  });

  @override
  State<AudienceSelectorWidget> createState() => _AudienceSelectorWidgetState();
}

class _AudienceSelectorWidgetState extends State<AudienceSelectorWidget> {
  final List<int> wards = List.generate(12, (index) => index + 1);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'लक्षित दर्शक',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),

        // All Citizens Option
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.selectedAudience == 'all'
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.outline,
              width: widget.selectedAudience == 'all' ? 2 : 1,
            ),
          ),
          child: RadioListTile<String>(
            value: 'all',
            groupValue: widget.selectedAudience,
            onChanged: (value) {
              if (value != null) {
                widget.onChanged(value, null);
              }
            },
            title: Row(
              children: [
                CustomIconWidget(
                  iconName: 'group',
                  size: 20,
                  color: widget.selectedAudience == 'all'
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                SizedBox(width: 2.w),
                Text(
                  'सम्पूर्ण नागरिक',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: widget.selectedAudience == 'all'
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: widget.selectedAudience == 'all'
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
              ],
            ),
            subtitle: Text(
              'सबै वडाका नागरिकहरूलाई देखिनेछ',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            activeColor: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),

        SizedBox(height: 2.h),

        // Specific Ward Option
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.selectedAudience == 'ward'
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.outline,
              width: widget.selectedAudience == 'ward' ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              RadioListTile<String>(
                value: 'ward',
                groupValue: widget.selectedAudience,
                onChanged: (value) {
                  if (value != null) {
                    // Default to ward 1 if no ward selected
                    int defaultWard = widget.selectedWard ?? 1;
                    widget.onChanged(value, defaultWard);
                  }
                },
                title: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'location_on',
                      size: 20,
                      color: widget.selectedAudience == 'ward'
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'निर्दिष्ट वडा',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: widget.selectedAudience == 'ward'
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight: widget.selectedAudience == 'ward'
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  'निर्दिष्ट वडाका नागरिकहरूलाई मात्र देखिनेछ',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                activeColor: AppTheme.lightTheme.colorScheme.primary,
              ),

              // Ward Selection Grid (shown when 'ward' is selected)
              if (widget.selectedAudience == 'ward') ...[
                Divider(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  height: 0,
                ),
                Container(
                  padding: EdgeInsets.all(3.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'वडा नम्बर छन्नुहोस्:',
                        style:
                        AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 2.h),

                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 6,
                          crossAxisSpacing: 2.w,
                          mainAxisSpacing: 1.h,
                          childAspectRatio: 1,
                        ),
                        itemCount: wards.length,
                        itemBuilder: (context, index) {
                          final ward = wards[index];
                          final isSelected = widget.selectedWard == ward;

                          return InkWell(
                            onTap: () {
                              widget.onChanged('ward', ward);
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : AppTheme.lightTheme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? AppTheme.lightTheme.colorScheme.primary
                                      : AppTheme.lightTheme.colorScheme.outline,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  ward.toString(),
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    color: isSelected
                                        ? AppTheme
                                        .lightTheme.colorScheme.onPrimary
                                        : AppTheme
                                        .lightTheme.colorScheme.onSurface,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 2.h),

                      // Selected Ward Display
                      if (widget.selectedWard != null)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'check_circle',
                                size: 20,
                                color: AppTheme.lightTheme.colorScheme.primary,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'छानिएको वडा: ${widget.selectedWard}',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color:
                                  AppTheme.lightTheme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
