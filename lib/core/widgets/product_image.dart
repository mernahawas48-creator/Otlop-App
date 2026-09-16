import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.imageUrl,
    this.fallbackUrl,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.borderRadius = BorderRadius.zero,
  });

  static const fallbackAsset = 'assets/images/otlob_logo_image.png';

  final String? imageUrl;
  final String? fallbackUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl?.trim() ?? '';
    final image = url.isEmpty
        ? _FallbackImage(width: width, height: height, fit: fit)
        : CachedNetworkImage(
            imageUrl: url,
            width: width,
            height: height,
            fit: fit,
            filterQuality: FilterQuality.high,
            fadeInDuration: const Duration(milliseconds: 120),
            placeholder: (_, _) =>
                _ImagePlaceholder(width: width, height: height),
            errorWidget: (_, _, _) =>
                fallbackUrl != null &&
                    fallbackUrl!.trim().isNotEmpty &&
                    fallbackUrl!.trim() != url
                ? ProductImage(
                    imageUrl: fallbackUrl,
                    width: width,
                    height: height,
                    fit: fit,
                  )
                : _FallbackImage(width: width, height: height, fit: fit),
          );

    if (borderRadius == BorderRadius.zero) {
      return image;
    }

    return ClipRRect(borderRadius: borderRadius, child: image);
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({this.width, this.height});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: const Color(0xffF7F7F7),
      alignment: Alignment.center,
      child: const SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Color(0xffD61355),
        ),
      ),
    );
  }
}

class _FallbackImage extends StatelessWidget {
  const _FallbackImage({this.width, this.height, required this.fit});

  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: const Color(0xffF7F7F7),
      alignment: Alignment.center,
      child: Image.asset(
        ProductImage.fallbackAsset,
        width: width,
        height: height,
        fit: fit,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}
