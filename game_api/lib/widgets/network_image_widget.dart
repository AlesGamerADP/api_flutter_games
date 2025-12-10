import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../config/api_config.dart';

/// Widget personalizado para cargar imágenes de red que funciona
/// correctamente tanto en web como en móvil.
/// 
/// En web, usa un proxy del backend para evitar problemas de CORS.
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

  /// Obtiene la URL de la imagen, usando proxy en web si es necesario
  String get _effectiveImageUrl {
    if (kIsWeb) {
      // En web, usar el proxy del backend para evitar problemas de CORS
      try {
        // Extraer la base URL de la API
        final apiBaseUrl = ApiConfig.baseUrl.replaceAll('/api/games', '');
        // Codificar la URL de la imagen para pasarla como parámetro
        final encodedUrl = Uri.encodeComponent(imageUrl);
        return '$apiBaseUrl/api/proxy-image?url=$encodedUrl';
      } catch (e) {
        // Si hay error, intentar con la URL original
        return imageUrl;
      }
    } else {
      // En móvil, usar la URL directamente
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
        // Si falla con el proxy en web, intentar con la URL original
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
      // Optimizar cache para web
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

