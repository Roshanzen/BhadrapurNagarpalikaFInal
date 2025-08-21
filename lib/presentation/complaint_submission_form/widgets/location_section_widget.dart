import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationSectionWidget extends StatefulWidget {
  final String? selectedLocation;
  final String? manualAddress;
  final Function(String?) onLocationChanged;
  final Function(String?) onManualAddressChanged;

  const LocationSectionWidget({
    super.key,
    required this.selectedLocation,
    required this.manualAddress,
    required this.onLocationChanged,
    required this.onManualAddressChanged,
  });

  @override
  State<LocationSectionWidget> createState() => _LocationSectionWidgetState();
}

class _LocationSectionWidgetState extends State<LocationSectionWidget> {
  final TextEditingController _addressController = TextEditingController();
  bool _isGettingLocation = false;

  @override
  void initState() {
    super.initState();
    _addressController.text = widget.manualAddress ?? '';
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isGettingLocation = true;
    });

    try {
      // Simulate GPS location fetch
      await Future.delayed(const Duration(seconds: 2));

      // Mock location data for demo
      const mockLocation = "27.7172° N, 85.3240° E";
      const mockAddress = "भद्रपुर नगरपालिका, वडा नम्बर ५, झापा";

      widget.onLocationChanged(mockLocation);
      _addressController.text = mockAddress;
      widget.onManualAddressChanged(mockAddress);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'स्थान सफलतापूर्वक प्राप्त भयो / Location fetched successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
            Text('स्थान प्राप्त गर्न समस्या भयो / Error getting location'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGettingLocation = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.location_on,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'स्थान / Location',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            if (widget.selectedLocation != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .tertiary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.gps_fixed,
                      size: 12,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'GPS',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),

        // GPS Location Button
        OutlinedButton.icon(
          onPressed: _isGettingLocation ? null : _getCurrentLocation,
          icon: _isGettingLocation
              ? SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          )
              : const Icon(Icons.my_location),
          label: Text(
            _isGettingLocation
                ? 'स्थान प्राप्त गर्दै... / Getting location...'
                : 'वर्तमान स्थान प्राप्त गर्नुहोस् / Get Current Location',
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),

        if (widget.selectedLocation != null) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'GPS निर्देशांक / GPS Coordinates',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  widget.selectedLocation!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontFamily: GoogleFonts.robotoMono().fontFamily,
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 16),

        // Manual Address Input
        TextFormField(
          controller: _addressController,
          maxLines: 2,
          decoration: InputDecoration(
            labelText: 'ठेगाना (वैकल्पिक) / Address (Optional)',
            hintText:
            'वडा नम्बर, टोल, घर नम्बर...\nWard number, Tole, House number...',
            prefixIcon: const Icon(Icons.home),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onChanged: widget.onManualAddressChanged,
          validator: (value) {
            if (widget.selectedLocation == null && (value?.isEmpty ?? true)) {
              return 'कृपया स्थान वा ठेगाना प्रविष्ट गर्नुहोस् / Please provide location or address';
            }
            return null;
          },
        ),

        const SizedBox(height: 12),

        // Map Preview Placeholder
        Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: widget.selectedLocation != null
              ? Stack(
            children: [
              // Mock map background
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  gradient: LinearGradient(
                    colors: [
                      Colors.green.withValues(alpha: 0.1),
                      Colors.blue.withValues(alpha: 0.1),
                    ],
                  ),
                ),
              ),
              // Mock map pin
              Center(
                child: Icon(
                  Icons.location_pin,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              // Mock map overlay
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'नक्सा पूर्वावलोकन / Map Preview',
                    style:
                    Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.map_outlined,
                size: 40,
                color: Theme.of(context).disabledColor,
              ),
              const SizedBox(height: 8),
              Text(
                'स्थान चयन गरेपछि नक्सा देखिनेछ\nMap will appear after location selection',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).disabledColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
