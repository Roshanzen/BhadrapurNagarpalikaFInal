import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'सहायता र प्रयोगकर्ता पुस्तिका',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 3.h),
            _buildQuickActions(),
            SizedBox(height: 3.h),
            _buildFAQSection(),
            SizedBox(height: 3.h),
            _buildTutorialSection(),
            SizedBox(height: 3.h),
            _buildContactSection(),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'कसरी मद्दत चाहियो?',
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'यो पुस्तिका तपाईंलाई एपको सबै सुविधाहरू बुझ्न मद्दत गर्नेछ।',
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'द्रुत कार्यहरू',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
        SizedBox(height: 2.h),
        _buildActionCard(
          icon: Icons.add_circle_outline,
          title: 'नयाँ गुनासो दर्ता गर्नुहोस्',
          description: 'समस्या रिपोर्ट गर्नका लागि स्टेप-बाइ-स्टेप गाइड',
          onTap: () {},
        ),
        _buildActionCard(
          icon: Icons.track_changes,
          title: 'गुनासोको स्थिति हेर्नुहोस्',
          description: 'तपाईंको गुनासोको हालको अवस्था ट्र्याक गर्नुहोस्',
          onTap: () {},
        ),
        _buildActionCard(
          icon: Icons.notifications,
          title: 'सूचना सेटिङहरू',
          description: 'सूचनाहरू कसरी व्यवस्थापन गर्ने',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(3.w),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 6.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      description,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAQSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'बारम्बार सोधिने प्रश्नहरू',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
        SizedBox(height: 2.h),
        _buildFAQItem(
          'गुनासो दर्ता गर्न कसरी?',
          'मुख्य स्क्रिनबाट "+" बटन थिच्नुहोस् र आवश्यक विवरणहरू भर्नुहोस्। फोटोहरू पनि संलग्न गर्न सक्नुहुन्छ।',
        ),
        _buildFAQItem(
          'गुनासोको स्थिति कसरी हेर्ने?',
          'प्रोफाइल सेक्सनबाट "मेरो गुनासोहरू" मा जानुहोस् र तपाईंको गुनासोहरूको सूची हेर्नुहोस्।',
        ),
        _buildFAQItem(
          'ठेगाना परिवर्तन गर्न कसरी?',
          'प्रोफाइल ड्रअरबाट "ठेगाना परिवर्तन" चयन गर्नुहोस् र नयाँ विवरणहरू अपडेट गर्नुहोस्।',
        ),
        _buildFAQItem(
          'सूचनाहरू कसरी सेट गर्ने?',
          'सेटिङ्गहरूमा गएर सूचना विकल्पहरू सक्षम वा अक्षम गर्नुहोस्।',
        ),
      ],
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Text(
            answer,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTutorialSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ट्यूटोरियलहरू',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
        SizedBox(height: 2.h),
        _buildTutorialCard(
          'गुनासो दर्ता गर्ने तरिका',
          '१. मुख्य पृष्ठमा "+" बटन थिच्नुहोस्\n'
          '२. गुनासोको प्रकार चयन गर्नुहोस्\n'
          '३. विस्तृत विवरण लेख्नुहोस्\n'
          '४. स्थान र फोटोहरू थप्नुहोस्\n'
          '५. पेश गर्नुहोस्',
        ),
        _buildTutorialCard(
          'प्रोफाइल अपडेट गर्ने तरिका',
          '१. प्रोफाइल ड्रअर खोल्नुहोस्\n'
          '२. "सेटिङ्गहरू" चयन गर्नुहोस्\n'
          '३. आवश्यक परिवर्तनहरू गर्नुहोस्\n'
          '४. सुरक्षित गर्नुहोस्',
        ),
      ],
    );
  }

  Widget _buildTutorialCard(String title, String steps) {
    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Padding(
        padding: EdgeInsets.all(3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              steps,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                height: 1.6,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'हामीसँग सम्पर्क गर्नुहोस्',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
        SizedBox(height: 2.h),
        _buildContactItem(
          Icons.phone,
          'हटलाइन',
          '०२३-५२५२५२',
        ),
        _buildContactItem(
          Icons.email,
          'इमेल',
          'support@bhadrapur.gov.np',
        ),
        _buildContactItem(
          Icons.location_on,
          'कार्यालय ठेगाना',
          'भद्रपुर नगरपालिका कार्यालय\nझापा, नेपाल',
        ),
        _buildContactItem(
          Icons.access_time,
          'कार्य समय',
          'सोम-शुक्र: ९:००-५:००\nशनि: ९:००-१:००',
        ),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String title, String detail) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppTheme.lightTheme.colorScheme.secondary,
              size: 5.w,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  detail,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}