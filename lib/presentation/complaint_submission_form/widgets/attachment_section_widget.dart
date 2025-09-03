import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AttachmentSectionWidget extends StatefulWidget {
  final List<XFile> attachments;
  final Function(List<XFile>) onAttachmentsChanged;

  const AttachmentSectionWidget({
    super.key,
    required this.attachments,
    required this.onAttachmentsChanged,
  });

  @override
  State<AttachmentSectionWidget> createState() =>
      _AttachmentSectionWidgetState();
}

class _AttachmentSectionWidgetState extends State<AttachmentSectionWidget> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 80,
      );

      if (pickedFiles.isNotEmpty) {
        final updatedAttachments = List<XFile>.from(widget.attachments)
          ..addAll(pickedFiles);
        widget.onAttachmentsChanged(updatedAttachments);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('फोटो छान्न समस्या भयो / Error picking images')),
        );
      }
    }
  }

  Future<void> _pickVideo() async {
    try {
      final XFile? pickedFile = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 5),
      );

      if (pickedFile != null) {
        final updatedAttachments = List<XFile>.from(widget.attachments)
          ..add(pickedFile);
        widget.onAttachmentsChanged(updatedAttachments);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('भिडियो छान्न समस्या भयो / Error picking video')),
        );
      }
    }
  }

  Future<void> _takePicture() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final updatedAttachments = List<XFile>.from(widget.attachments)
          ..add(pickedFile);
        widget.onAttachmentsChanged(updatedAttachments);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('फोटो खिच्न समस्या भयो / Error taking picture')),
        );
      }
    }
  }

  void _removeAttachment(int index) {
    final updatedAttachments = List<XFile>.from(widget.attachments)
      ..removeAt(index);
    widget.onAttachmentsChanged(updatedAttachments);
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'संलग्नक थप्नुहोस् / Add Attachment',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('फोटो खिच्नुहोस् / Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _takePicture();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('फोटो छान्नुहोस् / Choose Photos'),
              onTap: () {
                Navigator.pop(context);
                _pickImages();
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text('भिडियो छान्नुहोस् / Choose Video'),
              onTap: () {
                Navigator.pop(context);
                _pickVideo();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentThumbnail(XFile file, int index) {
    final isVideo =
    file.path.toLowerCase().contains(RegExp(r'\.(mp4|mov|avi|mkv)$'));

    return Container(
      width: 80,
      height: 80,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: isVideo
                ? Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey[300],
              child: const Icon(
                Icons.play_circle_filled,
                size: 32,
                color: Colors.white,
              ),
            )
                : kIsWeb
                ? FutureBuilder<Uint8List>(
              future: file.readAsBytes(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Image.memory(
                    snapshot.data!,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  );
                }
                return Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            )
                : Image.file(
              File(file.path),
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => _removeAttachment(index),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  size: 14,
                  color: Theme.of(context).colorScheme.onError,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.attach_file,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'संलग्नक / Attachments',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              '${widget.attachments.length}/5',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Add attachment button
        InkWell(
          onTap: widget.attachments.length < 5 ? _showAttachmentOptions : null,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.attachments.length < 5
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).disabledColor,
                style: BorderStyle.solid,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
              color: widget.attachments.length < 5
                  ? Theme.of(context)
                  .colorScheme
                  .primary
                  .withValues(alpha: 0.05)
                  : Theme.of(context).disabledColor.withValues(alpha: 0.05),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.add_photo_alternate,
                  size: 32,
                  color: widget.attachments.length < 5
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).disabledColor,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.attachments.length < 5
                      ? 'फोटो वा भिडियो थप्नुहोस्\nTap to add photos or videos'
                      : 'अधिकतम 5 फाइल मात्र\nMaximum 5 files only',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: widget.attachments.length < 5
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).disabledColor,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Show attachment thumbnails
        if (widget.attachments.isNotEmpty) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.attachments.length,
              itemBuilder: (context, index) => _buildAttachmentThumbnail(
                widget.attachments[index],
                index,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
