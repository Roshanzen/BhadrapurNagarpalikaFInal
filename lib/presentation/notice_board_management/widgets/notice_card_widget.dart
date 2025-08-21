import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NoticeCardWidget extends StatelessWidget {
  final Map<String, dynamic> notice;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const NoticeCardWidget({
    super.key,
    required this.notice,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  Color get _statusColor {
    switch (notice['status']) {
      case 'published':
        return AppTheme.successLight;
      case 'draft':
        return AppTheme.warningLight;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String get _statusText {
    switch (notice['status']) {
      case 'published':
        return 'प्रकाशित';
      case 'draft':
        return 'ड्राफ्ट';
      default:
        return 'अज्ञात';
    }
  }

  Color get _priorityColor {
    switch (notice['priority']) {
      case 'high':
        return AppTheme.errorLight;
      case 'medium':
        return AppTheme.warningLight;
      case 'low':
        return AppTheme.successLight;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: Key(notice['id']),
        background: Container(
            margin: EdgeInsets.symmetric(vertical: 1.h),
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.secondary,
                borderRadius: BorderRadius.circular(12)),
            alignment: Alignment.centerLeft,
            child: Row(children: [
              CustomIconWidget(iconName: 'edit', color: Colors.white, size: 24),
              SizedBox(width: 2.w),
              Text('सम्पादन',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w600)),
            ])),
        secondaryBackground: Container(
            margin: EdgeInsets.symmetric(vertical: 1.h),
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
                color: AppTheme.errorLight,
                borderRadius: BorderRadius.circular(12)),
            alignment: Alignment.centerRight,
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Text('मेटाउने',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w600)),
              SizedBox(width: 2.w),
              CustomIconWidget(
                  iconName: 'delete', color: Colors.white, size: 24),
            ])),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            // Edit action
            onEdit();
            return false;
          } else if (direction == DismissDirection.endToStart) {
            // Delete action - show confirmation
            return await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                    title: const Text('सूचना मेटाउने'),
                    content: const Text(
                        'के तपाईं यो सूचना मेटाउन निश्चित हुनुहुन्छ?'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('रद्द गर्नुहोस्')),
                      ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.errorLight),
                          child: const Text('मेटाउनुहोस्')),
                    ]));
          }
          return false;
        },
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            onDelete();
          }
        },
        child: Card(
            margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
            elevation: 2,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Row
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Thumbnail
                                if (notice['thumbnailImage'] != null)
                                  Container(
                                      width: 20.w,
                                      height: 12.h,
                                      margin: EdgeInsets.only(right: 3.w),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                                color: AppTheme.shadowLight,
                                                blurRadius: 4,
                                                offset: const Offset(0, 2)),
                                          ]),
                                      child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(8),
                                          child: CustomImageWidget(
                                              imageUrl: notice['thumbnailImage'],
                                              fit: BoxFit.cover))),

                                // Content
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          // Title and Status
                                          Row(children: [
                                            Expanded(
                                                child: Text(notice['title'],
                                                    style: AppTheme.lightTheme
                                                        .textTheme.titleMedium
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight.w600,
                                                        color: AppTheme
                                                            .lightTheme
                                                            .colorScheme
                                                            .onSurface),
                                                    maxLines: 2,
                                                    overflow:
                                                    TextOverflow.ellipsis)),
                                            SizedBox(width: 2.w),
                                            Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 2.w,
                                                    vertical: 0.5.h),
                                                decoration: BoxDecoration(
                                                    color: _statusColor,
                                                    borderRadius:
                                                    BorderRadius.circular(12)),
                                                child: Text(_statusText,
                                                    style: AppTheme.lightTheme
                                                        .textTheme.labelSmall
                                                        ?.copyWith(
                                                        color: Colors.white,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                        fontSize: 10.sp))),
                                          ]),

                                          SizedBox(height: 1.h),

                                          // Excerpt
                                          Text(notice['excerpt'],
                                              style: AppTheme
                                                  .lightTheme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                  color: AppTheme
                                                      .lightTheme
                                                      .colorScheme
                                                      .onSurfaceVariant,
                                                  height: 1.4),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis),

                                          SizedBox(height: 2.h),

                                          // Meta Information
                                          Row(children: [
                                            // Author
                                            CustomIconWidget(
                                                iconName: 'person',
                                                size: 14,
                                                color: AppTheme.lightTheme
                                                    .colorScheme.onSurfaceVariant),
                                            SizedBox(width: 1.w),
                                            Text(notice['author'],
                                                style: AppTheme
                                                    .lightTheme.textTheme.bodySmall
                                                    ?.copyWith(
                                                    color: AppTheme
                                                        .lightTheme
                                                        .colorScheme
                                                        .onSurfaceVariant)),

                                            SizedBox(width: 4.w),

                                            // Date
                                            CustomIconWidget(
                                                iconName: 'calendar_today',
                                                size: 14,
                                                color: AppTheme.lightTheme
                                                    .colorScheme.onSurfaceVariant),
                                            SizedBox(width: 1.w),
                                            Text(
                                                notice['publicationDate'] ??
                                                    notice['scheduledDate'] ??
                                                    'मिति सेट गरिएको छैन',
                                                style: AppTheme
                                                    .lightTheme.textTheme.bodySmall
                                                    ?.copyWith(
                                                    color: AppTheme
                                                        .lightTheme
                                                        .colorScheme
                                                        .onSurfaceVariant)),
                                          ]),
                                        ])),
                              ]),

                          SizedBox(height: 2.h),

                          // Footer Row
                          Row(children: [
                            // Priority Indicator
                            Container(
                                width: 3.w,
                                height: 3.w,
                                decoration: BoxDecoration(
                                    color: _priorityColor,
                                    shape: BoxShape.circle)),
                            SizedBox(width: 2.w),

                            // Target Audience
                            Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                    color: AppTheme
                                        .lightTheme.colorScheme.primary
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                    notice['targetAudience'] == 'all'
                                        ? 'सबै नागरिक'
                                        : 'वडा ${notice['ward']}',
                                    style: AppTheme
                                        .lightTheme.textTheme.labelSmall
                                        ?.copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.primary,
                                        fontWeight: FontWeight.w500))),

                            const Spacer(),

                            // View Count (for published notices)
                            if (notice['status'] == 'published') ...[
                              CustomIconWidget(
                                  iconName: 'visibility',
                                  size: 16,
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant),
                              SizedBox(width: 1.w),
                              Text('${notice['viewCount']}',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(width: 3.w),
                            ],

                            // Action Menu
                            PopupMenuButton<String>(
                                icon: CustomIconWidget(
                                    iconName: 'more_vert',
                                    size: 20,
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant),
                                onSelected: (value) {
                                  switch (value) {
                                    case 'edit':
                                      onEdit();
                                      break;
                                    case 'delete':
                                      onDelete();
                                      break;
                                    case 'preview':
                                      onTap();
                                      break;
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                      value: 'preview',
                                      child: Row(children: [
                                        CustomIconWidget(
                                            iconName: 'visibility',
                                            size: 20,
                                            color: AppTheme.lightTheme
                                                .colorScheme.primary),
                                        SizedBox(width: 2.w),
                                        const Text('पूर्वावलोकन'),
                                      ])),
                                  PopupMenuItem(
                                      value: 'edit',
                                      child: Row(children: [
                                        CustomIconWidget(
                                            iconName: 'edit',
                                            size: 20,
                                            color: AppTheme.lightTheme
                                                .colorScheme.secondary),
                                        SizedBox(width: 2.w),
                                        const Text('सम्पादन गर्नुहोस्'),
                                      ])),
                                  PopupMenuItem(
                                      value: 'delete',
                                      child: Row(children: [
                                        CustomIconWidget(
                                            iconName: 'delete',
                                            size: 20,
                                            color: AppTheme.errorLight),
                                        SizedBox(width: 2.w),
                                        const Text('मेटाउनुहोस्'),
                                      ])),
                                ]),
                          ]),
                        ])))));
  }
}