import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'गोपनीयता नीति',
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
            _buildLastUpdated(),
            SizedBox(height: 3.h),
            _buildSection(
              '१. जानकारी संकलन',
              'हामी तपाईंको व्यक्तिगत जानकारीहरू जस्तै नाम, ठेगाना, फोन नम्बर, र इमेल ठेगाना संकलन गर्दछौं जब तपाईं हाम्रो सेवाहरू प्रयोग गर्नुहुन्छ। यो जानकारी गुनासोहरू प्रशोधन गर्न र तपाईंलाई राम्रो सेवा प्रदान गर्न आवश्यक छ।',
            ),
            _buildSection(
              '२. जानकारीको प्रयोग',
              'संकलित जानकारीहरू निम्न उद्देश्यहरूका लागि प्रयोग गरिन्छ:\n\n'
              '• गुनासोहरूको प्रशोधन र समाधान\n'
              '• तपाईंलाई सूचना र अपडेटहरू पठाउन\n'
              '• सेवाको गुणस्तर सुधार गर्न\n'
              '• कानुनी आवश्यकताहरू पूरा गर्न',
            ),
            _buildSection(
              '३. जानकारीको सुरक्षण',
              'हामी तपाईंको व्यक्तिगत जानकारीको सुरक्षाका लागि प्रतिबद्ध छौं। हामी उन्नत सुरक्षा उपायहरू अपनाउँछौं जसमा:\n\n'
              '• डेटा एन्क्रिप्शन\n'
              '• सुरक्षित सर्भरहरू\n'
              '• सीमित पहुँच नियन्त्रण\n'
              '• नियमित सुरक्षा अपडेटहरू',
            ),
            _buildSection(
              '४. जानकारी साझेदारी',
              'हामी तपाईंको व्यक्तिगत जानकारी तेस्रो पक्षहरूसँग बिना तपाईंको सहमति बाँड्दैनौं। जानकारी निम्न अवस्थामा मात्र साझेदार गरिन्छ:\n\n'
              '• कानुनी आवश्यकता भएमा\n'
              '• सार्वजनिक सुरक्षा संरक्षणका लागि\n'
              '• हाम्रा सेवा प्रदायकहरूसँग (गोपनीयता सम्झौताअन्तर्गत)',
            ),
            _buildSection(
              '५. तपाईंका अधिकारहरू',
              'तपाईंको निम्न अधिकारहरू छन्:\n\n'
              '• आफ्नो जानकारी पहुँच गर्न\n'
              '• गलत जानकारी सच्याउन\n'
              '• जानकारी मेटाउन अनुरोध गर्न\n'
              '• जानकारीको प्रसोधनमा आपत्ति जनाउन',
            ),
            _buildSection(
              '६. कुकीहरू र ट्र्याकिङ',
              'हामी तपाईंको अनुभव सुधार गर्न कुकीहरू प्रयोग गर्दछौं। तपाईं आफ्नो ब्राउजर सेटिङहरू मार्फत कुकीहरू नियन्त्रण गर्न सक्नुहुन्छ।',
            ),
            _buildSection(
              '७. बालबालिकाको गोपनीयता',
              'यो सेवा १८ वर्षभन्दा कम उमेरका बालबालिकाका लागि होइन। हामी जानाजान बालबालिकाको जानकारी संकलन गर्दैनौं।',
            ),
            _buildSection(
              '८. नीति परिवर्तनहरू',
              'हामी समय समयमा यो गोपनीयता नीति अपडेट गर्न सक्छौं। महत्वपूर्ण परिवर्तनहरू भएमा तपाईंलाई सूचित गरिनेछ।',
            ),
            _buildSection(
              '९. सम्पर्क गर्नुहोस्',
              'यदि तपाईंलाई यस गोपनीयता नीतिका बारेमा कुनै प्रश्नहरू छन् भने, कृपया हामीलाई सम्पर्क गर्नुहोस्:\n\n'
              'इमेल: privacy@bhadrapur.gov.np\n'
              'फोन: ०२३-५२५२५२\n'
              'ठेगाना: भद्रपुर नगरपालिका कार्यालय, झापा',
            ),
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
          'गोपनीयता नीति',
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'भद्रपुर नगरपालिका गुनासो पोर्टल',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildLastUpdated() {
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
            Icons.update,
            color: AppTheme.lightTheme.colorScheme.secondary,
            size: 5.w,
          ),
          SizedBox(width: 2.w),
          Text(
            'अन्तिम अपडेट: २०८१ आश्विन २१',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 3.h),
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
          SizedBox(height: 1.h),
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
}