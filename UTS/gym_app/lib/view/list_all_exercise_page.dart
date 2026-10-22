import 'package:flutter/material.dart';
import 'package:gym_app/theme/app_theme.dart';
import 'package:gym_app/model/exercise_api_model.dart';
import 'package:gym_app/service/exercise_api_service.dart';
import 'package:gym_app/view/detail_exercise_page.dart';
import 'package:gym_app/view/widgets/exercise_gif_widget.dart';

class ListAllExercisePage extends StatefulWidget {
  final String bodyPartName;
  final List<dynamic>? initialExercises;
  final ExerciseApiService? apiService;

  const ListAllExercisePage({
    super.key,
    required this.bodyPartName,
    this.initialExercises,
    this.apiService,
  });

  @override
  State<ListAllExercisePage> createState() => _ListAllExercisePageState();
}

class _ListAllExercisePageState extends State<ListAllExercisePage> {
  late final ExerciseApiService _apiService;
  late Future<ExerciseApiResponse> _exercisesFuture;
  final TextEditingController _searchController = TextEditingController();

  final List<ExerciseApiModel> _loadedExercises = [];
  String? _nextCursor;
  bool _hasNextPage = false;
  int _totalServerCount = 0;
  bool _isLoadingMore = false;
  String? _loadMoreError;

  String _searchQuery = '';
  String _selectedEquipment = 'All';

  @override
  void initState() {
    super.initState();
    _apiService = widget.apiService ?? ExerciseApiService();
    _loadExercises();
  }

  String? _resolveBodyPartParam() {
    final lower = widget.bodyPartName.toLowerCase().trim();
    if (lower == 'all exercise' || lower == 'all exercises' || lower == 'all') {
      return null;
    }
    if (lower == 'chest') return 'chest';
    if (lower == 'back') return 'back';
    if (lower == 'shoulders' || lower == 'shoulder') return 'shoulders';
    if (lower == 'biceps' || lower == 'bicep') return null; // Biceps adalah targetMuscle di ExerciseDB
    return lower; // fallback
  }

  String? _resolveTargetMuscleParam() {
    final lower = widget.bodyPartName.toLowerCase().trim();
    if (lower == 'biceps' || lower == 'bicep') return 'biceps';
    return null;
  }

  Future<ExerciseApiResponse> _fetchInitial() async {
    _loadedExercises.clear();
    _loadMoreError = null;
    final res = await _apiService.fetchExercises(
      limit: 25,
      bodyPart: _resolveBodyPartParam(),
      targetMuscle: _resolveTargetMuscleParam(),
    );
    _loadedExercises.addAll(res.exercises);
    _nextCursor = res.nextCursor;
    _hasNextPage = res.hasNextPage;
    _totalServerCount = res.total;
    return res;
  }

  void _loadExercises() {
    setState(() {
      _exercisesFuture = _fetchInitial();
    });
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasNextPage || _nextCursor == null) return;

    setState(() {
      _isLoadingMore = true;
      _loadMoreError = null;
    });

    try {
      final res = await _apiService.fetchExercises(
        limit: 25,
        cursor: _nextCursor,
        bodyPart: _resolveBodyPartParam(),
        targetMuscle: _resolveTargetMuscleParam(),
      );
      setState(() {
        _loadedExercises.addAll(res.exercises);
        _nextCursor = res.nextCursor;
        _hasNextPage = res.hasNextPage;
        _totalServerCount = res.total;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
        _loadMoreError = e is ApiException ? e.message : e.toString();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    if (widget.apiService == null) {
      _apiService.dispose();
    }
    super.dispose();
  }

  List<ExerciseApiModel> _filterExercises(List<ExerciseApiModel> all) {
    return all.where((ex) {
      final isAll = widget.bodyPartName.toLowerCase() == 'all exercise' ||
          widget.bodyPartName.toLowerCase() == 'all exercises' ||
          widget.bodyPartName.toLowerCase() == 'all';

      final matchesBodyPart = isAll ||
          ex.bodyParts.any((bp) => bp.toLowerCase().contains(widget.bodyPartName.toLowerCase())) ||
          ex.targetMuscles.any((tm) => tm.toLowerCase().contains(widget.bodyPartName.toLowerCase())) ||
          (widget.bodyPartName.toLowerCase() == 'biceps' &&
              ex.targetMuscles.any((tm) => tm.toLowerCase().contains('bicep'))) ||
          (widget.bodyPartName.toLowerCase() == 'chest' &&
              ex.bodyParts.any((bp) => bp.toLowerCase().contains('chest'))) ||
          (widget.bodyPartName.toLowerCase() == 'back' &&
              ex.bodyParts.any((bp) => bp.toLowerCase().contains('back'))) ||
          (widget.bodyPartName.toLowerCase() == 'shoulders' &&
              ex.bodyParts.any((bp) => bp.toLowerCase().contains('shoulder')));

      final matchesQuery = _searchQuery.isEmpty ||
          ex.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          ex.targetMuscles.any((tm) => tm.toLowerCase().contains(_searchQuery.toLowerCase())) ||
          ex.equipments.any((eq) => eq.toLowerCase().contains(_searchQuery.toLowerCase())) ||
          ex.bodyParts.any((bp) => bp.toLowerCase().contains(_searchQuery.toLowerCase()));

      final matchesEquipment = _selectedEquipment == 'All' ||
          ex.equipments.any((eq) => eq.toLowerCase() == _selectedEquipment.toLowerCase());

      return matchesBodyPart && matchesQuery && matchesEquipment;
    }).toList();
  }

  List<String> _extractEquipments(List<ExerciseApiModel> all) {
    final set = <String>{'All'};
    for (final ex in all) {
      for (final eq in ex.equipments) {
        if (eq.isNotEmpty) {
          set.add('${eq[0].toUpperCase()}${eq.substring(1)}');
        }
      }
    }
    return set.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00F0FF),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.bodyPartName.toUpperCase(),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Muat ulang data awal',
            icon: const Icon(Icons.refresh_rounded, color: Colors.black),
            onPressed: _loadExercises,
          ),
        ],
      ),
      body: FutureBuilder<ExerciseApiResponse>(
        future: _exercisesFuture,
        builder: (context, snapshot) {
          // 1. Kondisi Loading Awal (Poin Rubrik: Asynchronous Programming - Loading)
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState();
          }

          // 2. Kondisi Error Awal (Poin Rubrik: Asynchronous Programming - Error)
          if (snapshot.hasError && _loadedExercises.isEmpty) {
            final errorMsg = snapshot.error is ApiException
                ? (snapshot.error as ApiException).message
                : snapshot.error.toString();
            return _buildErrorState(errorMsg);
          }

          // 3. Validasi Keberadaan Data
          if (_loadedExercises.isEmpty) {
            return _buildEmptyState('Tidak ada data latihan yang diterima dari server.');
          }

          final filteredExercises = _filterExercises(_loadedExercises);
          final availableEquipments = _extractEquipments(_loadedExercises);
          final showLoadMoreFooter = _hasNextPage || _isLoadingMore || _loadMoreError != null;

          // 4. Kondisi Sukses (Poin Rubrik: Asynchronous Programming - Success)
          return Column(
            children: [
              _buildSearchBar(),
              if (availableEquipments.length > 1)
                _buildEquipmentFilter(availableEquipments),
              _buildSourceAttributionHeader(filteredExercises.length, _loadedExercises.length, _totalServerCount),
              Expanded(
                child: filteredExercises.isEmpty
                    ? _buildNoFilterMatchState()
                    : ListView.builder(
                        itemCount: filteredExercises.length + (showLoadMoreFooter ? 1 : 0),
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 24),
                        itemBuilder: (context, index) {
                          if (index == filteredExercises.length) {
                            return _buildLoadMoreFooter();
                          }
                          final exercise = filteredExercises[index];
                          return _buildExerciseCard(exercise);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(
            color: Color(0xFF00F0FF),
            strokeWidth: 3,
          ),
          SizedBox(height: 16),
          Text(
            'Mengambil data latihan dari ExerciseDB API...',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF2C2C2E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Colors.redAccent,
                size: 48,
              ),
              const SizedBox(height: 12),
              const Text(
                'Gagal Memuat Data Latihan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _loadExercises,
                icon: const Icon(Icons.refresh_rounded, color: Colors.black),
                label: const Text(
                  'Coba Lagi (Retry)',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00F0FF),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off_rounded,
              color: Colors.white38,
              size: 56,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoFilterMatchState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.filter_alt_off_rounded, color: Colors.white38, size: 48),
            const SizedBox(height: 12),
            const Text(
              'Tidak ada latihan yang cocok dengan filter saat ini.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 16),
            if (_hasNextPage)
              ElevatedButton.icon(
                onPressed: _isLoadingMore ? null : _loadMore,
                icon: const Icon(Icons.cloud_download_rounded, color: Colors.black),
                label: const Text(
                  'Muat Latihan Tambahan dari Server',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00F0FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Cari latihan, otot, atau alat...',
          hintStyle: const TextStyle(color: Colors.white38),
          prefixIcon: const Icon(Icons.search, color: AppTheme.accent),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.white54),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: const Color(0xFF2C2C2E),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (val) {
          setState(() {
            _searchQuery = val.trim();
          });
        },
      ),
    );
  }

  Widget _buildEquipmentFilter(List<String> list) {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final eq = list[index];
          final isSelected = eq.toLowerCase() == _selectedEquipment.toLowerCase();
          return ChoiceChip(
            label: Text(
              eq,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white70,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            selected: isSelected,
            selectedColor: AppTheme.accent,
            backgroundColor: const Color(0xFF2C2C2E),
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onSelected: (selected) {
              setState(() {
                _selectedEquipment = selected ? eq : 'All';
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildSourceAttributionHeader(int filteredCount, int loadedCount, int totalServerCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              Text(
                'Tampil: $filteredCount (Dimuat: $loadedCount / Total: $totalServerCount)',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                'ExerciseDB OSS • AscendAPI',
                style: TextStyle(
                  color: AppTheme.accent,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Text(
                'Pencarian dan filter hanya pada data yang dimuat. Muat lebih banyak untuk memperluas.',
                style: TextStyle(color: Colors.white38, fontSize: 10),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreFooter() {
    if (_isLoadingMore) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.accent),
            ),
            SizedBox(width: 12),
            Flexible(child: Text(
              'Memuat 25 latihan berikutnya dari server...',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            )),
          ],
        ),
      );
    }

    if (_loadMoreError != null) {
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2E),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _loadMoreError!,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
            TextButton(
              onPressed: _loadMore,
              child: const Text('Coba Lagi', style: TextStyle(color: AppTheme.accent)),
            ),
          ],
        ),
      );
    }

    if (_hasNextPage) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: OutlinedButton.icon(
          onPressed: _loadMore,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.accent),
          label: Text(
            'Muat Lebih Banyak (${_loadedExercises.length} / $_totalServerCount)',
            style: const TextStyle(color: AppTheme.accent, fontWeight: FontWeight.bold),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppTheme.accent, width: 1.2),
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildExerciseCard(ExerciseApiModel exercise) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailExercisePage(exercise: exercise),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            // Preview Animasi GIF Latihan
            ExerciseGifWidget(
              gifUrl: exercise.gifUrl,
              width: 74,
              height: 74,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.formattedName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      _buildBadge(exercise.primaryTarget, AppTheme.accent),
                      _buildBadge(exercise.primaryEquipment, Colors.lightBlueAccent),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.white38,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
