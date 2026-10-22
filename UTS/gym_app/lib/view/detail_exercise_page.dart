import 'package:flutter/material.dart';
import 'package:gym_app/theme/app_theme.dart';
import 'package:gym_app/model/exercise_api_model.dart';
import 'package:gym_app/view/widgets/exercise_gif_widget.dart';

class DetailExercisePage extends StatelessWidget {
  final ExerciseApiModel exercise;

  const DetailExercisePage({
    super.key,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Detail Latihan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Tampilan Demonstrasi Animasi GIF Berukuran Besar (Tahap 3)
            Container(
              width: double.infinity,
              height: 240,
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: ExerciseGifWidget(
                  gifUrl: exercise.gifUrl,
                  width: double.infinity,
                  height: 240,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 2. Nama Latihan
            Text(
              exercise.formattedName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 12),

            // 3. Chip Informasi Inti (Target Muscle, Body Part, Equipment)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildInfoChip(
                  icon: Icons.fitness_center_rounded,
                  label: 'Target: ${exercise.primaryTarget}',
                  color: AppTheme.accent,
                ),
                _buildInfoChip(
                  icon: Icons.accessibility_new_rounded,
                  label: 'Bagian: ${exercise.primaryBodyPart}',
                  color: AppTheme.accent,
                ),
                _buildInfoChip(
                  icon: Icons.handyman_rounded,
                  label: 'Alat: ${exercise.primaryEquipment}',
                  color: Colors.orangeAccent,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 4. Otot Sekunder (Jika Ada)
            if (exercise.secondaryMuscles.isNotEmpty) ...[
              _buildSection(
                title: "Otot Sekunder (Secondary Muscles)",
                content: exercise.secondaryMuscles
                    .map((m) => '${m[0].toUpperCase()}${m.substring(1)}')
                    .join(', '),
              ),
              const SizedBox(height: 16),
            ],

            // 5. Langkah Instruksi Pelaksanaan (Step-by-Step Instructions)
            _buildInstructionsSection(exercise.instructions),
            const SizedBox(height: 24),

            // 6. Atribusi Sumber Data Resmi ExerciseDB OSS (AscendAPI)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.info_outline_rounded, color: AppTheme.accent, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Data dan animasi bersumber dari ExerciseDB OSS oleh AscendAPI (Penggunaan Non-Komersial / Edukasi UTS).',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 11,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Flexible(child: Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionsSection(List<String> instructions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Instruksi Pelaksanaan Gerakan",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (instructions.isEmpty)
          const Text(
            "Tidak ada instruksi khusus yang tercatat untuk latihan ini.",
            style: TextStyle(color: Colors.white54, fontSize: 14),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: instructions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final raw = instructions[index];
              final cleanText = raw.replaceFirst(RegExp(r'^Step:\s*\d+\s*', caseSensitive: false), '');
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: AppTheme.accent,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      cleanText,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
      ],
    );
  }
}
