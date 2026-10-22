import 'package:flutter/material.dart';

class ExerciseGifWidget extends StatelessWidget {
  final String gifUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const ExerciseGifWidget({
    super.key,
    required this.gifUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(10);

    if (gifUrl.isEmpty || !gifUrl.startsWith('http')) {
      return _buildPlaceholder(radius, 'No Animation');
    }

    return ClipRRect(
      borderRadius: radius,
      child: Image.network(
        gifUrl,
        width: width,
        height: height,
        fit: fit,
        gaplessPlayback: true,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          final totalBytes = loadingProgress.expectedTotalBytes;
          final loadedBytes = loadingProgress.cumulativeBytesLoaded;
          final progress = (totalBytes != null && totalBytes > 0)
              ? loadedBytes / totalBytes
              : null;

          return Container(
            width: width,
            height: height,
            color: const Color(0xFF2C2C2E),
            alignment: Alignment.center,
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 2.2,
                color: const Color(0xFF00F0FF),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder(radius, 'GIF Unavailable');
        },
      ),
    );
  }

  Widget _buildPlaceholder(BorderRadius radius, String label) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: radius,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.fitness_center_rounded,
            color: Colors.white38,
            size: 28,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
