import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_system/widgets/image_viewer_scree.dart';
import 'package:flutter/material.dart';

class ImageContentWidget extends StatelessWidget {
  final String imageUrl;
  const ImageContentWidget({required this.imageUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ImageViewerScreen(imageUrl: imageUrl),
          ),
        );
      },
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        fadeInDuration: Duration(milliseconds: 100),
        placeholderFadeInDuration: Duration(milliseconds: 50),
        placeholder: (context, url) => Container(color: Colors.grey[300]),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }
}
