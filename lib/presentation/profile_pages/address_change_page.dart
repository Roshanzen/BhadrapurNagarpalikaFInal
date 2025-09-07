import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class AddressChangePage extends StatefulWidget {
  const AddressChangePage({super.key});

  @override
  State<AddressChangePage> createState() => _AddressChangePageState();
}

class _AddressChangePageState extends State<AddressChangePage> {
  final _formKey = GlobalKey<FormState>();
  final _wardController = TextEditingController();
  final _toleController = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();

  @override
  void dispose() {
    _wardController.dispose();
    _toleController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ठेगाना परिवर्तन',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 4.h),
              _buildWardSelector(),
              SizedBox(height: 3.h),
              _buildAddressFields(),
              SizedBox(height: 4.h),
              _buildSubmitButton(),
              SizedBox(height: 2.h),
              _buildNote(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'तपाईंको ठेगाना अपडेट गर्नुहोस्',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'कृपया तपाईंको हालको ठेगाना विवरणहरू प्रविष्ट गर्नुहोस्। परिवर्तनहरू प्रमाणित गर्न आवश्यक हुन सक्छ।',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildWardSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'वार्ड नम्बर',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
          ),
          hint: Text('वार्ड चयन गर्नुहोस्'),
          items: List.generate(35, (index) => (index + 1).toString())
              .map((ward) => DropdownMenuItem(
                    value: ward,
                    child: Text('वार्ड $ward'),
                  ))
              .toList(),
          onChanged: (value) {
            _wardController.text = value ?? '';
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'कृपया वार्ड चयन गर्नुहोस्';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildAddressFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ठेगाना विवरणहरू',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        TextFormField(
          controller: _toleController,
          decoration: InputDecoration(
            labelText: 'टोल/बस्ती',
            hintText: 'तपाईंको टोल वा बस्तीको नाम',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'कृपया टोल/बस्ती प्रविष्ट गर्नुहोस्';
            }
            return null;
          },
        ),
        SizedBox(height: 2.h),
        TextFormField(
          controller: _cityController,
          decoration: InputDecoration(
            labelText: 'नगरपालिका/गाउँपालिका',
            hintText: 'भद्रपुर नगरपालिका',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'कृपया नगरपालिका/गाउँपालिका प्रविष्ट गर्नुहोस्';
            }
            return null;
          },
        ),
        SizedBox(height: 2.h),
        TextFormField(
          controller: _districtController,
          decoration: InputDecoration(
            labelText: 'जिल्ला',
            hintText: 'झापा',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'कृपया जिल्ला प्रविष्ट गर्नुहोस्';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitAddressChange,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'ठेगाना परिवर्तन गर्नुहोस्',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildNote() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.secondaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppTheme.lightTheme.colorScheme.secondary,
            size: 5.w,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              'नोट: ठेगाना परिवर्तन पछि प्रमाणित गर्न आवश्यक पर्न सक्छ। कृपया सही विवरणहरू प्रविष्ट गर्नुहोस्।',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitAddressChange() {
    if (_formKey.currentState?.validate() ?? false) {
      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'ठेगाना परिवर्तन पुष्टि',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'तपाईं निम्न ठेगानामा परिवर्तन गर्न चाहनुहुन्छ:',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              Text(
                'वार्ड: ${_wardController.text}',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              Text(
                'टोल: ${_toleController.text}',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              Text(
                'नगरपालिका: ${_cityController.text}',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              Text(
                'जिल्ला: ${_districtController.text}',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('रद्द गर्नुहोस्'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _processAddressChange();
              },
              child: Text('पुष्टि गर्नुहोस्'),
            ),
          ],
        ),
      );
    }
  }

  void _processAddressChange() {
    // Show loading
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('ठेगाना परिवर्तन हुँदैछ...'),
        duration: Duration(seconds: 2),
      ),
    );

    // Simulate processing
    Future.delayed(Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ठेगाना सफलतापूर्वक परिवर्तन गरियो!'),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        ),
      );
      Navigator.pop(context);
    });
  }
}