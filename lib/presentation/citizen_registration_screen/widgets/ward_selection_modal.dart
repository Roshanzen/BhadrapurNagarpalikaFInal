import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WardSelectionModal extends StatefulWidget {
  final Function(int) onWardSelected;

  const WardSelectionModal({
    Key? key,
    required this.onWardSelected,
  }) : super(key: key);

  @override
  State<WardSelectionModal> createState() => _WardSelectionModalState();
}

class _WardSelectionModalState extends State<WardSelectionModal> {
  final TextEditingController _searchController = TextEditingController();
  int? _selectedWard;
  List<Map<String, dynamic>> _filteredWards = [];

  final List<Map<String, dynamic>> _wards = [
    {
      'number': 1,
      'nameNepali': 'वडा नं. १',
      'nameEnglish': 'Ward No. 1',
      'area': 'केन्द्रीय क्षेत्र'
    },
    {
      'number': 2,
      'nameNepali': 'वडा नं. २',
      'nameEnglish': 'Ward No. 2',
      'area': 'पूर्वी क्षेत्र'
    },
    {
      'number': 3,
      'nameNepali': 'वडा नं. ३',
      'nameEnglish': 'Ward No. 3',
      'area': 'पश्चिमी क्षेत्र'
    },
    {
      'number': 4,
      'nameNepali': 'वडा नं. ४',
      'nameEnglish': 'Ward No. 4',
      'area': 'उत्तरी क्षेत्र'
    },
    {
      'number': 5,
      'nameNepali': 'वडा नं. ५',
      'nameEnglish': 'Ward No. 5',
      'area': 'दक्षिणी क्षेत्र'
    },
    {
      'number': 6,
      'nameNepali': 'वडा नं. ६',
      'nameEnglish': 'Ward No. 6',
      'area': 'मध्य पूर्वी क्षेत्र'
    },
    {
      'number': 7,
      'nameNepali': 'वडा नं. ७',
      'nameEnglish': 'Ward No. 7',
      'area': 'मध्य पश्चिमी क्षेत्र'
    },
    {
      'number': 8,
      'nameNepali': 'वडा नं. ८',
      'nameEnglish': 'Ward No. 8',
      'area': 'उत्तर पूर्वी क्षेत्र'
    },
    {
      'number': 9,
      'nameNepali': 'वडा नं. ९',
      'nameEnglish': 'Ward No. 9',
      'area': 'उत्तर पश्चिमी क्षेत्र'
    },
    {
      'number': 10,
      'nameNepali': 'वडा नं. १०',
      'nameEnglish': 'Ward No. 10',
      'area': 'दक्षिण पूर्वी क्षेत्र'
    },
    {
      'number': 11,
      'nameNepali': 'वडा नं. ११',
      'nameEnglish': 'Ward No. 11',
      'area': 'दक्षिण पश्चिमी क्षेत्र'
    },
    {
      'number': 12,
      'nameNepali': 'वडा नं. १२',
      'nameEnglish': 'Ward No. 12',
      'area': 'औद्योगिक क्षेत्र'
    },
    {
      'number': 13,
      'nameNepali': 'वडा नं. १३',
      'nameEnglish': 'Ward No. 13',
      'area': 'व्यापारिक क्षेत्र'
    },
    {
      'number': 14,
      'nameNepali': 'वडा नं. १४',
      'nameEnglish': 'Ward No. 14',
      'area': 'आवासीय क्षेत्र'
    },
    {
      'number': 15,
      'nameNepali': 'वडा नं. १५',
      'nameEnglish': 'Ward No. 15',
      'area': 'कृषि क्षेत्र'
    },
    {
      'number': 16,
      'nameNepali': 'वडा नं. १६',
      'nameEnglish': 'Ward No. 16',
      'area': 'शिक्षा क्षेत्र'
    },
    {
      'number': 17,
      'nameNepali': 'वडा नं. १७',
      'nameEnglish': 'Ward No. 17',
      'area': 'स्वास्थ्य क्षेत्र'
    },
    {
      'number': 18,
      'nameNepali': 'वडा नं. १८',
      'nameEnglish': 'Ward No. 18',
      'area': 'पर्यटन क्षेत्र'
    },
    {
      'number': 19,
      'nameNepali': 'वडा नं. १९',
      'nameEnglish': 'Ward No. 19',
      'area': 'खेलकुद क्षेत्र'
    },
    {
      'number': 20,
      'nameNepali': 'वडा नं. २०',
      'nameEnglish': 'Ward No. 20',
      'area': 'सांस्कृतिक क्षेत्र'
    },
  ];

  @override
  void initState() {
    super.initState();
    _filteredWards = List.from(_wards);
    _searchController.addListener(_filterWards);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterWards() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredWards = _wards.where((ward) {
        final wardNumber = (ward['number'] as int).toString();
        final nameNepali = (ward['nameNepali'] as String).toLowerCase();
        final nameEnglish = (ward['nameEnglish'] as String).toLowerCase();
        final area = (ward['area'] as String).toLowerCase();

        return wardNumber.contains(query) ||
            nameNepali.contains(query) ||
            nameEnglish.contains(query) ||
            area.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Your Ward',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // Search field
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search ward number or area...',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(12),
                  child: CustomIconWidget(
                    iconName: 'search',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                  },
                  icon: CustomIconWidget(
                    iconName: 'clear',
                    color:
                    AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                )
                    : null,
              ),
            ),
          ),

          // Ward list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: _filteredWards.length,
              itemBuilder: (context, index) {
                final ward = _filteredWards[index];
                final wardNumber = ward['number'] as int;
                final isSelected = _selectedWard == wardNumber;

                return Container(
                  margin: EdgeInsets.only(bottom: 1.h),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedWard = wardNumber;
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1)
                              : AppTheme.lightTheme.colorScheme.surface,
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 12.w,
                              height: 6.h,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : AppTheme.lightTheme.colorScheme.outline
                                    .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  wardNumber.toString(),
                                  style: AppTheme
                                      .lightTheme.textTheme.titleLarge
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
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ward['nameNepali'] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.titleMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? AppTheme
                                          .lightTheme.colorScheme.primary
                                          : AppTheme
                                          .lightTheme.colorScheme.onSurface,
                                    ),
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Text(
                                    ward['area'] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium
                                        ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              CustomIconWidget(
                                iconName: 'check_circle',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 24,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Confirm button
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            child: ElevatedButton(
              onPressed: _selectedWard != null
                  ? () {
                widget.onWardSelected(_selectedWard!);
                Navigator.pop(context);
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: Text(
                'Confirm Ward Selection',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
