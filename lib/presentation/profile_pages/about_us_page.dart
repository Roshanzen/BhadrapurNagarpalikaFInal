import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'हाम्रो बारेमा',
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
            _buildMissionSection(),
            SizedBox(height: 3.h),
            _buildVisionSection(),
            SizedBox(height: 3.h),
            _buildServicesSection(),
            SizedBox(height: 3.h),
            _buildTeamSection(),
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
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.lightTheme.colorScheme.primary.withOpacity(0.1),
                AppTheme.lightTheme.colorScheme.secondary.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'location_city',
                  color: Colors.white,
                  size: 8.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'भद्रपुर नगरपालिका',
                      style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                    Text(
                      'गुनासो व्यवस्थापन प्रणाली',
                      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          'हाम्रो नगरपालिका बारेमा',
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'भद्रपुर नगरपालिका झापा जिल्लाको एक प्रमुख नगरपालिका हो। हामीले नागरिकहरूको सेवामा उच्च प्राथमिकता दिँदै आधुनिक प्रविधि र पारदर्शी शासन प्रणाली अपनाएका छौं।',
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            height: 1.6,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildMissionSection() {
    return _buildInfoCard(
      icon: 'flag',
      title: 'हाम्रो लक्ष्य',
      content: 'नागरिकहरूको जीवनस्तर उकास्न, पारदर्शी शासन सुनिश्चित गर्न र विकासका कार्यहरू तीव्र गतिमा अघि बढाउनु। सबै नागरिकहरूको पहुँचमा गुणस्तरीय सार्वजनिक सेवाहरू उपलब्ध गराउनु।',
      color: AppTheme.lightTheme.colorScheme.primary,
    );
  }

  Widget _buildVisionSection() {
    return _buildInfoCard(
      icon: 'visibility',
      title: 'हाम्रो दृष्टि',
      content: 'भद्रपुरलाई एक नमूना नगरपालिका बनाउनु। जहाँ नागरिकहरू सुखी, समृद्ध र विकासप्रेमी छन्। प्रविधिको उच्चतम प्रयोग गरी सेवा प्रवाह गर्नु र भ्रष्टाचारमुक्त शासन प्रणाली कायम गर्नु।',
      color: AppTheme.lightTheme.colorScheme.secondary,
    );
  }

  Widget _buildServicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'हाम्रा सेवाहरू',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
        SizedBox(height: 2.h),
        _buildServiceItem(
          icon: 'assignment',
          title: 'गुनासो व्यवस्थापन',
          description: 'नागरिकहरूका गुनासाहरू तुरुन्त दर्ता गरी समाधान गर्ने प्रणाली',
        ),
        _buildServiceItem(
          icon: 'notifications',
          title: 'सूचना प्रणाली',
          description: 'नगर विकासका कार्यहरू र सूचनाहरू समयमै नागरिकहरूलाई उपलब्ध गराउने',
        ),
        _buildServiceItem(
          icon: 'location_city',
          title: 'नगर सुविधाहरू',
          description: 'सडक, बत्ती, पानी, फोहोर व्यवस्थापन लगायतका नगर सुविधाहरू',
        ),
        _buildServiceItem(
          icon: 'school',
          title: 'शिक्षा सेवाहरू',
          description: 'गुणस्तरीय शिक्षा प्रदान गर्ने विद्यालयहरू र शैक्षिक कार्यक्रमहरू',
        ),
        _buildServiceItem(
          icon: 'local_hospital',
          title: 'स्वास्थ्य सेवाहरू',
          description: 'नागरिकहरूको स्वास्थ्य सेवाका लागि अस्पताल र स्वास्थ्य केन्द्रहरू',
        ),
      ],
    );
  }

  Widget _buildTeamSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'हाम्रो टिम',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 6.w,
                backgroundColor: AppTheme.lightTheme.colorScheme.primary.withOpacity(0.1),
                child: CustomIconWidget(
                  iconName: 'person',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 6.w,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'नगर प्रमुख',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'भद्रपुर नगरपालिका',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'प्रविधि र सेवाको माध्यमबाट नागरिकहरूको जीवनस्तर उकास्ने प्रतिबद्धता',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
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
          icon: 'location_on',
          title: 'ठेगाना',
          detail: 'भद्रपुर नगरपालिका कार्यालय\nझापा, नेपाल',
        ),
        _buildContactItem(
          icon: 'phone',
          title: 'फोन',
          detail: '+९७७-२३-५२५२५२',
        ),
        _buildContactItem(
          icon: 'email',
          title: 'इमेल',
          detail: 'info@bhadrapur.gov.np',
        ),
        _buildContactItem(
          icon: 'access_time',
          title: 'कार्य समय',
          detail: 'सोम-शुक्र: ९:००-५:००\nशनि: ९:००-१:००',
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required String icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(1.5.w),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: icon,
                  color: Colors.white,
                  size: 5.w,
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            content,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              height: 1.6,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem({
    required String icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: icon,
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
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  description,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required String icon,
    required String title,
    required String detail,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: icon,
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
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.3.h),
                Text(
                  detail,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    height: 1.4,
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