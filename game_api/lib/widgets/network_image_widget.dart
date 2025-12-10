import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../config/api_config.dart';

class NetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const NetworkImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  String get _effectiveImageUrl {
    if (kIsWeb) {
      try {
        final apiBaseUrl = ApiConfig.baseUrl.replaceAll('/api/games', '');
        final encodedUrl = Uri.encodeComponent(imageUrl);
        return '$apiBaseUrl/api/proxy-image?url=$encodedUrl';
      } catch (e) {
        return imageUrl;
      }
    } else {
      return imageUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Image.network(
      _effectiveImageUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return placeholder ?? _buildDefaultPlaceholder();
      },
      errorBuilder: (context, error, stackTrace) {
        if (kIsWeb && _effectiveImageUrl != imageUrl) {
          debugPrint('Error con proxy, intentando URL original: $error');
          return Image.network(
            imageUrl,
            width: width,
            height: height,
            fit: fit,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return placeholder ?? _buildDefaultPlaceholder();
            },
            errorBuilder: (context, error, stackTrace) {
              return errorWidget ?? _buildDefaultError();
            },
          );
        }
        return errorWidget ?? _buildDefaultError();
      },
      cacheWidth: kIsWeb && width != null ? width!.toInt() : null,
      cacheHeight: kIsWeb && height != null ? height!.toInt() : null,
    );
  }

  Widget _buildDefaultPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF374151),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildDefaultError() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF374151),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.videogame_asset,
        color: Colors.grey[600],
        size: width != null && height != null
            ? (width! < height! ? width! * 0.4 : height! * 0.4)
            : 32,
      ),
    );
  }
}

