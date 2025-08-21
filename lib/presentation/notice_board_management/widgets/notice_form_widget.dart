import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/custom_image_widget.dart';
import '../../complaint_submission_form/widgets/priority_selector_widget.dart';
import './audience_selector_widget.dart';

class NoticeFormWidget extends StatefulWidget {
  final Map<String, dynamic>? notice;
  final Function(Map<String, dynamic>) onSave;
  final Function(Map<String, dynamic>)? onUpdate;

  const NoticeFormWidget({
    super.key,
    this.notice,
    required this.onSave,
    this.onUpdate,
  });

  @override
  State<NoticeFormWidget> createState() => _NoticeFormWidgetState();
}

class _NoticeFormWidgetState extends State<NoticeFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _excerptController = TextEditingController();

  String _selectedPriority = 'medium';
  String _selectedAudience = 'all';
  int? _selectedWard;
  DateTime? _scheduledDate;
  XFile? _selectedImage;
  bool _isLoading = false;
  bool _autoSaveDraft = true;

  final List<String> _priorities = ['low', 'medium', 'high'];
  final Map<String, String> _priorityLabels = {
    'low': 'न्यून',
    'medium': 'मध्यम',
    'high': 'उच्च',
  };

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.notice != null) {
      final notice = widget.notice!;
      _titleController.text = notice['title'] ?? '';
      _contentController.text = notice['content'] ?? '';
      _excerptController.text = notice['excerpt'] ?? '';
      _selectedPriority = notice['priority'] ?? 'medium';
      _selectedAudience = notice['targetAudience'] ?? 'all';
      _selectedWard = notice['ward'];
      if (notice['scheduledDate'] != null) {
        // Parse Nepali date format - simplified for demo
        _scheduledDate = DateTime.now().add(const Duration(days: 3));
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _excerptController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 800,
        imageQuality: 80);

    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _selectScheduledDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _scheduledDate ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                      primary: AppTheme.lightTheme.colorScheme.primary)),
              child: child!);
        });

    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          builder: (context, child) {
            return Theme(
                data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                        primary: AppTheme.lightTheme.colorScheme.primary)),
                child: child!);
          });

      if (time != null) {
        setState(() {
          _scheduledDate = DateTime(
              picked.year, picked.month, picked.day, time.hour, time.minute);
        });
      }
    }
  }

  void _onAudienceChanged(String audience, int? ward) {
    setState(() {
      _selectedAudience = audience;
      _selectedWard = ward;
    });
  }

  String _generateNoticeId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return 'N' +
        String.fromCharCodes(Iterable.generate(
            3, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  Future<void> _saveNotice({required bool publish}) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    final noticeData = {
      'id': widget.notice?['id'] ?? _generateNoticeId(),
      'title': _titleController.text.trim(),
      'content': _contentController.text.trim(),
      'excerpt': _excerptController.text.trim().isEmpty
          ? _generateExcerpt(_contentController.text.trim())
          : _excerptController.text.trim(),
      'status': publish ? 'published' : 'draft',
      'priority': _selectedPriority,
      'targetAudience': _selectedAudience,
      'ward': _selectedWard,
      'author': 'राम बहादुर श्रेष्ठ', // Mock author
      'publicationDate': publish ? '२०८१/०५/०८' : null,
      'scheduledDate': _scheduledDate != null ? '२०८१/०५/१०' : null,
      'thumbnailImage':
      _selectedImage?.path ?? widget.notice?['thumbnailImage'],
      'viewCount': widget.notice?['viewCount'] ?? 0,
    };

    setState(() {
      _isLoading = false;
    });

    if (widget.notice != null && widget.onUpdate != null) {
      widget.onUpdate!(noticeData);
    } else {
      widget.onSave(noticeData);
    }

    Navigator.pop(context);
  }

  String _generateExcerpt(String content) {
    if (content.length <= 100) return content;
    return '${content.substring(0, 100)}...';
  }

  void _previewNotice() {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('शीर्षक र सामग्री आवश्यक छ'),
          backgroundColor: AppTheme.errorLight));
      return;
    }

    final previewData = {
      'id': 'PREVIEW',
      'title': _titleController.text.trim(),
      'content': _contentController.text.trim(),
      'excerpt': _excerptController.text.trim().isEmpty
          ? _generateExcerpt(_contentController.text.trim())
          : _excerptController.text.trim(),
      'status': 'draft',
      'priority': _selectedPriority,
      'targetAudience': _selectedAudience,
      'ward': _selectedWard,
      'author': 'राम बहादुर श्रेष्ठ',
      'publicationDate': null,
      'scheduledDate': _scheduledDate != null ? '२०८१/०५/१०' : null,
      'thumbnailImage':
      _selectedImage?.path ?? widget.notice?['thumbnailImage'],
      'viewCount': 0,
    };

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => _NoticePreviewScreen(notice: previewData)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 90.h,
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.scaffoldBackgroundColor,
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(children: [
          // Handle Bar
          Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.only(top: 2.h),
              decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  borderRadius: BorderRadius.circular(2))),

          // Header
          Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3)))),
              child: Row(children: [
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                        iconName: 'close',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 24)),
                Expanded(
                    child: Text(
                        widget.notice != null
                            ? 'सूचना सम्पादन गर्नुहोस्'
                            : 'नयाँ सूचना बनाउनुहोस्',
                        style: AppTheme.lightTheme.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center)),
                TextButton(
                    onPressed: _previewNotice,
                    child: const Text('पूर्वावलोकन')),
              ])),

          // Form Content
          Expanded(
              child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                      padding: EdgeInsets.all(4.w),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title Field
                            TextFormField(
                                controller: _titleController,
                                decoration: InputDecoration(
                                    labelText: 'सूचनाको शीर्षक *',
                                    hintText: 'सूचनाको शीर्षक लेख्नुहोस्',
                                    counterText:
                                    '${_titleController.text.length}/100'),
                                maxLength: 100,
                                validator: (value) {
                                  if (value?.trim().isEmpty ?? true) {
                                    return 'शीर्षक आवश्यक छ';
                                  }
                                  return null;
                                },
                                onChanged: (value) => setState(() {})),

                            SizedBox(height: 3.h),

                            // Excerpt Field
                            TextFormField(
                                controller: _excerptController,
                                decoration: InputDecoration(
                                    labelText: 'संक्षिप्त विवरण',
                                    hintText:
                                    'सूचनाको संक्षिप्त विवरण (खाली छोडे सामग्रीबाट स्वतः बन्नेछ)',
                                    counterText:
                                    '${_excerptController.text.length}/200'),
                                maxLength: 200,
                                maxLines: 3,
                                onChanged: (value) => setState(() {})),

                            SizedBox(height: 3.h),

                            // Content Field
                            TextFormField(
                                controller: _contentController,
                                decoration: InputDecoration(
                                    labelText: 'सूचनाको सामग्री *',
                                    hintText:
                                    'सूचनाको विस्तृत सामग्री लेख्नुहोस्',
                                    counterText:
                                    '${_contentController.text.length}/5000',
                                    alignLabelWithHint: true),
                                maxLength: 5000,
                                maxLines: 8,
                                validator: (value) {
                                  if (value?.trim().isEmpty ?? true) {
                                    return 'सामग्री आवश्यक छ';
                                  }
                                  return null;
                                },
                                onChanged: (value) => setState(() {})),

                            SizedBox(height: 3.h),

                            // Featured Image
                            Text('चित्र संलग्न गर्नुहोस्',
                                style: AppTheme.lightTheme.textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w600)),
                            SizedBox(height: 1.h),

                            InkWell(
                                onTap: _pickImage,
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                    width: double.infinity,
                                    height: 20.h,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: AppTheme
                                                .lightTheme.colorScheme.outline,
                                            style: BorderStyle.solid)),
                                    child: _selectedImage != null ||
                                        widget.notice?['thumbnailImage'] !=
                                            null
                                        ? Stack(children: [
                                      ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(12),
                                          child: _selectedImage != null
                                              ? Image.file(
                                              File(_selectedImage!
                                                  .path),
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover)
                                              : CustomImageWidget(
                                              imageUrl: widget.notice?['thumbnailImage'] ?? '',
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover)),
                                      Positioned(
                                          top: 1.h,
                                          right: 2.w,
                                          child: CircleAvatar(
                                              backgroundColor:
                                              Colors.black54,
                                              radius: 2.5.h,
                                              child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _selectedImage =
                                                      null;
                                                    });
                                                  },
                                                  icon: CustomIconWidget(
                                                      iconName: 'close',
                                                      color: Colors.white,
                                                      size: 20)))),
                                    ])
                                        : Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          CustomIconWidget(
                                              iconName:
                                              'add_photo_alternate',
                                              size: 48,
                                              color: AppTheme
                                                  .lightTheme
                                                  .colorScheme
                                                  .onSurfaceVariant),
                                          SizedBox(height: 1.h),
                                          Text(
                                              'चित्र थप्नको लागि क्लिक गर्नुहोस्',
                                              style: AppTheme.lightTheme
                                                  .textTheme.bodyMedium
                                                  ?.copyWith(
                                                  color: AppTheme
                                                      .lightTheme
                                                      .colorScheme
                                                      .onSurfaceVariant)),
                                        ]))),

                            SizedBox(height: 3.h),

                            // Priority Selection
                            Text('प्राथमिकता',
                                style: AppTheme.lightTheme.textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w600)),
                            SizedBox(height: 1.h),

                            Wrap(
                                spacing: 2.w,
                                children: _priorities.map((priority) {
                                  final isSelected =
                                      _selectedPriority == priority;
                                  return FilterChip(
                                      label: Text(_priorityLabels[priority]!),
                                      selected: isSelected,
                                      onSelected: (selected) {
                                        setState(() {
                                          _selectedPriority = priority;
                                        });
                                      },
                                      backgroundColor: AppTheme
                                          .lightTheme.colorScheme.surface,
                                      selectedColor: AppTheme
                                          .lightTheme.colorScheme.primary
                                          .withValues(alpha: 0.2),
                                      checkmarkColor: AppTheme
                                          .lightTheme.colorScheme.primary,
                                      labelStyle: AppTheme
                                          .lightTheme.textTheme.bodyMedium
                                          ?.copyWith(
                                          color: isSelected
                                              ? AppTheme.lightTheme
                                              .colorScheme.primary
                                              : AppTheme.lightTheme
                                              .colorScheme.onSurface));
                                }).toList()),

                            SizedBox(height: 3.h),

                            // Audience Selector
                            AudienceSelectorWidget(
                                selectedAudience: _selectedAudience,
                                selectedWard: _selectedWard,
                                onChanged: _onAudienceChanged),

                            SizedBox(height: 3.h),

                            // Schedule Publication
                            Text('प्रकाशन समयतालिका',
                                style: AppTheme.lightTheme.textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w600)),
                            SizedBox(height: 1.h),

                            InkWell(
                                onTap: _selectScheduledDate,
                                child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(4.w),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppTheme.lightTheme
                                                .colorScheme.outline),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Row(children: [
                                      CustomIconWidget(
                                          iconName: 'schedule',
                                          size: 24,
                                          color: AppTheme.lightTheme.colorScheme
                                              .onSurfaceVariant),
                                      SizedBox(width: 3.w),
                                      Text(
                                          _scheduledDate != null
                                              ? 'समयतालिका: २०८१/०५/१० श' // Mock Nepali date format
                                              : 'तुरुन्त प्रकाशन गर्नुहोस्',
                                          style: AppTheme
                                              .lightTheme.textTheme.bodyMedium
                                              ?.copyWith(
                                              color: _scheduledDate != null
                                                  ? AppTheme.lightTheme
                                                  .colorScheme.onSurface
                                                  : AppTheme
                                                  .lightTheme
                                                  .colorScheme
                                                  .onSurfaceVariant)),
                                      const Spacer(),
                                      if (_scheduledDate != null)
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _scheduledDate = null;
                                              });
                                            },
                                            icon: CustomIconWidget(
                                                iconName: 'close',
                                                size: 20,
                                                color: AppTheme
                                                    .lightTheme
                                                    .colorScheme
                                                    .onSurfaceVariant)),
                                    ]))),

                            SizedBox(height: 5.h),
                          ])))),

          // Action Buttons
          Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3)))),
              child: Row(children: [
                Expanded(
                    child: OutlinedButton(
                        onPressed: _isLoading
                            ? null
                            : () => _saveNotice(publish: false),
                        style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 3.h)),
                        child: _isLoading
                            ? SizedBox(
                            width: 5.w,
                            height: 5.w,
                            child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme
                                        .lightTheme.colorScheme.primary)))
                            : const Text('ड्राफ्ट सेभ गर्नुहोस्'))),
                SizedBox(width: 4.w),
                Expanded(
                    child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () => _saveNotice(publish: true),
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 3.h)),
                        child: _isLoading
                            ? SizedBox(
                            width: 5.w,
                            height: 5.w,
                            child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme
                                        .lightTheme.colorScheme.onPrimary)))
                            : Text(_scheduledDate != null
                            ? 'समयतालिका सेट गर्नुहोस्'
                            : 'प्रकाशित गर्नुहोस्'))),
              ])),
        ]));
  }
}

class _NoticePreviewScreen extends StatelessWidget {
  final Map<String, dynamic> notice;

  const _NoticePreviewScreen({required this.notice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
            title: const Text('सूचना पूर्वावलोकन'),
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(4.w),
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Status Preview Banner
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                      color: AppTheme.warningLight.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.warningLight)),
                  child: Row(children: [
                    CustomIconWidget(
                        iconName: 'preview',
                        size: 20,
                        color: AppTheme.warningLight),
                    SizedBox(width: 2.w),
                    Text('यो पूर्वावलोकन हो - नागरिकहरूलाई यसरी देखिनेछ',
                        style: AppTheme.lightTheme.textTheme.bodySmall
                            ?.copyWith(
                            color: AppTheme.warningLight,
                            fontWeight: FontWeight.w500)),
                  ])),

              SizedBox(height: 3.h),

              // Notice content would be displayed here similar to the main preview
              // This is a simplified version
              Text(notice['title'],
                  style: AppTheme.lightTheme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w600)),

              SizedBox(height: 2.h),

              Text(notice['content'],
                  style: AppTheme.lightTheme.textTheme.bodyLarge
                      ?.copyWith(height: 1.6)),
            ])));
  }
}