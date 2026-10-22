import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:gym_app/model/exercise_api_model.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

class ExerciseApiResponse {
  final List<ExerciseApiModel> exercises;
  final int total;
  final bool hasNextPage;
  final String? nextCursor;

  const ExerciseApiResponse({
    required this.exercises,
    required this.total,
    required this.hasNextPage,
    this.nextCursor,
  });
}

class ExerciseApiService {
  static const String baseUrl = 'https://oss.exercisedb.dev/api/v1';
  static const Duration defaultTimeout = Duration(seconds: 15);

  final http.Client _client;

  ExerciseApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<ExerciseApiResponse> fetchExercises({
    int limit = 20,
    String? cursor,
    String? bodyPart,
    String? targetMuscle,
    String? name,
  }) async {
    final queryParams = <String, String>{
      'limit': limit.clamp(1, 25).toString(),
    };

    // ExerciseDB OSS OpenAPI mendefinisikan parameter 'after' untuk forward cursor pagination
    if (cursor != null && cursor.isNotEmpty) {
      queryParams['after'] = cursor;
    }

    // Filter server-side jika diberikan
    if (bodyPart != null && bodyPart.isNotEmpty && bodyPart.toLowerCase() != 'all exercise') {
      queryParams['bodyParts'] = bodyPart.toLowerCase();
    }
    if (targetMuscle != null && targetMuscle.isNotEmpty) {
      queryParams['targetMuscles'] = targetMuscle.toLowerCase();
    }
    if (name != null && name.trim().isNotEmpty) {
      queryParams['name'] = name.trim();
    }

    final uri = Uri.parse('$baseUrl/exercises').replace(queryParameters: queryParams);

    try {
      final response = await _client.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'GetFitGym-UTS/1.0',
        },
      ).timeout(defaultTimeout);

      return _handleResponse(response);
    } on SocketException catch (e) {
      throw ApiException('Tidak dapat terhubung ke server ExerciseDB. Periksa koneksi internet Anda. ($e)');
    } on TimeoutException catch (_) {
      throw const ApiException('Permintaan data ke ExerciseDB melebihi batas waktu (timeout 15 detik). Silakan coba lagi.');
    } on FormatException catch (e) {
      throw ApiException('Gagal mengolah format data respons dari server. ($e)');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Terjadi kendala saat memuat data latihan: $e');
    }
  }

  ExerciseApiResponse _handleResponse(http.Response response) {
    final statusCode = response.statusCode;

    if (statusCode >= 200 && statusCode < 300) {
      final dynamic decoded = json.decode(response.body);

      if (decoded is! Map<String, dynamic>) {
        throw const ApiException('Format data JSON dari server tidak sesuai standar.');
      }

      final success = decoded['success'] as bool? ?? false;
      if (!success) {
        throw ApiException('Server ExerciseDB merespons status gagal.', statusCode: statusCode);
      }

      final dataList = decoded['data'];
      if (dataList is! List) {
        throw const ApiException('Struktur atribut data latihan tidak berbentuk list.');
      }

      final exercises = dataList
          .whereType<Map<String, dynamic>>()
          .map((item) => ExerciseApiModel.fromJson(item))
          .toList();

      final meta = decoded['meta'] as Map<String, dynamic>?;
      final total = meta?['total'] as int? ?? exercises.length;
      final hasNextPage = meta?['hasNextPage'] as bool? ?? false;
      final nextCursor = meta?['nextCursor'] as String?;

      return ExerciseApiResponse(
        exercises: exercises,
        total: total,
        hasNextPage: hasNextPage,
        nextCursor: nextCursor,
      );
    } else if (statusCode == 429) {
      throw const ApiException('Batas panggilan API (rate limit) tercapai. Silakan tunggu beberapa saat.', statusCode: 429);
    } else if (statusCode >= 500) {
      throw ApiException('Server ExerciseDB sedang mengalami kendala internal.', statusCode: statusCode);
    } else {
      throw ApiException('Permintaan gagal dengan status server: $statusCode', statusCode: statusCode);
    }
  }

  void dispose() {
    _client.close();
  }
}
