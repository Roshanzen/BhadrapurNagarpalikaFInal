
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final BoxFit fit;

  /// Optional widget to show when the image fails to load.
  /// If null, a default asset image is shown.
  final Widget? errorWidget;

  const CustomImageWidget({
    Key? key,
    required this.imageUrl,
    this.width = 50,
    this.height = 50,
    this.fit = BoxFit.cover,
    this.errorWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl ??
          'https://images.unsplash.com/photo-1584824486509-112e4181ff6b?q=80&w=2940&auto=format&fit=crop',
      width: width,
      height: height,
      fit: fit,

      // Use caller-supplied widget if provided, else fallback to a colored container.
      errorWidget: (context, url, error) =>
      errorWidget ??
          Container(
            width: width,
            height: height,
            color: Colors.grey[300],
            child: Icon(
              Icons.image_not_supported,
              color: Colors.grey[600],
              size: width * 0.4, // Scale icon relative to container size
            ),
          ),

      placeholder: (context, url) => Container(
        width: width,
        height: height,
        color: Colors.grey[200],
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
