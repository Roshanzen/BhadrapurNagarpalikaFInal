import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MediaItem {
  final String id;
  final String url;
  final String type; // 'image' or 'video'
  final String? caption;
  final DateTime uploadedAt;

  MediaItem({
    required this.id,
    required this.url,
    required this.type,
    this.caption,
    required this.uploadedAt,
  });
}

class MediaGalleryWidget extends StatefulWidget {
  final List<MediaItem> mediaItems;
  final bool allowFullScreen;

  const MediaGalleryWidget({
    super.key,
    required this.mediaItems,
    this.allowFullScreen = true,
  });

  @override
  State<MediaGalleryWidget> createState() => _MediaGalleryWidgetState();
}

class _MediaGalleryWidgetState extends State<MediaGalleryWidget> {
  void _showFullScreenMedia(MediaItem mediaItem, int index) {
    if (!widget.allowFullScreen) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenMediaViewer(
          mediaItems: widget.mediaItems,
          initialIndex: index,
        ),
      ),
    );
  }

  Widget _buildMediaThumbnail(MediaItem mediaItem, int index) {
    return GestureDetector(
      onTap: () => _showFullScreenMedia(mediaItem, index),
      child: Container(
        width: 100,
        height: 100,
        margin: EdgeInsets.only(
            right: index == widget.mediaItems.length - 1 ? 16 : 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: mediaItem.type == 'video'
                  ? Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black87,
                child: const Center(
                  child: Icon(
                    Icons.play_circle_filled,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              )
                  : CachedNetworkImage(
                imageUrl: mediaItem.url,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),

            // Media type indicator
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(
                  mediaItem.type == 'video' ? Icons.videocam : Icons.photo,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),

            // Full screen indicator
            if (widget.allowFullScreen)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.fullscreen,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mediaItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.photo_library,
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${widget.mediaItems.length} फाइल',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 16),
            itemCount: widget.mediaItems.length,
            itemBuilder: (context, index) => _buildMediaThumbnail(
              widget.mediaItems[index],
              index,
            ),
          ),
        ),
      ],
    );
  }
}

class FullScreenMediaViewer extends StatefulWidget {
  final List<MediaItem> mediaItems;
  final int initialIndex;

  const FullScreenMediaViewer({
    super.key,
    required this.mediaItems,
    required this.initialIndex,
  });

  @override
  State<FullScreenMediaViewer> createState() => _FullScreenMediaViewerState();
}

class _FullScreenMediaViewerState extends State<FullScreenMediaViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.8),
        foregroundColor: Colors.white,
        title: Text(
          '${_currentIndex + 1} / ${widget.mediaItems.length}',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Implement share functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Share functionality not implemented'),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // Implement download functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Download functionality not implemented'),
                ),
              );
            },
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.mediaItems.length,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        itemBuilder: (context, index) {
          final mediaItem = widget.mediaItems[index];

          return Center(
            child: mediaItem.type == 'video'
                ? Container(
              color: Colors.black,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.play_circle_filled,
                      color: Colors.white,
                      size: 64,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Video Player not implemented\nClick to play video',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            )
                : InteractiveViewer(
              child: CachedNetworkImage(
                imageUrl: mediaItem.url,
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                errorWidget: (context, url, error) => const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error,
                        color: Colors.white,
                        size: 48,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Image failed to load',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: widget.mediaItems[_currentIndex].caption != null
          ? Container(
        padding: const EdgeInsets.all(16),
        color: Colors.black.withValues(alpha: 0.8),
        child: Text(
          widget.mediaItems[_currentIndex].caption!,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      )
          : null,
    );
  }
}
