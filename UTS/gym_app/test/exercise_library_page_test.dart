import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_app/model/exercise_api_model.dart';
import 'package:gym_app/service/exercise_api_service.dart';
import 'package:gym_app/view/list_all_exercise_page.dart';

class FakeExerciseApiService extends ExerciseApiService {
  FakeExerciseApiService(this.handler);

  final Future<ExerciseApiResponse> Function() handler;
  int calls = 0;

  @override
  Future<ExerciseApiResponse> fetchExercises({
    int limit = 20,
    String? cursor,
    String? bodyPart,
    String? targetMuscle,
    String? name,
  }) {
    calls++;
    return handler();
  }

  @override
  void dispose() {}
}

const sampleExercise = ExerciseApiModel(
  exerciseId: 'test-1',
  name: 'test curl',
  gifUrl: '',
  bodyParts: ['upper arms'],
  equipments: ['dumbbell'],
  targetMuscles: ['biceps'],
  secondaryMuscles: [],
  instructions: ['Lift the dumbbell.'],
);

void main() {
  Widget page(FakeExerciseApiService service) => MaterialApp(
        home: ListAllExercisePage(
          bodyPartName: 'All Exercise',
          apiService: service,
        ),
      );

  testWidgets('menampilkan loading lalu success tanpa request ulang saat rebuild', (tester) async {
    final completer = Future<ExerciseApiResponse>.delayed(
      const Duration(milliseconds: 50),
      () => const ExerciseApiResponse(
        exercises: [sampleExercise],
        total: 1,
        hasNextPage: false,
      ),
    );
    final service = FakeExerciseApiService(() => completer);

    await tester.pumpWidget(page(service));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.text('Test Curl'), findsOneWidget);
    expect(service.calls, 1);

    await tester.pump();
    expect(service.calls, 1);
  });

  testWidgets('menampilkan empty state', (tester) async {
    final service = FakeExerciseApiService(
      () async => const ExerciseApiResponse(
        exercises: [],
        total: 0,
        hasNextPage: false,
      ),
    );

    await tester.pumpWidget(page(service));
    await tester.pumpAndSettle();

    expect(find.text('Tidak ada data latihan yang diterima dari server.'), findsOneWidget);
  });

  testWidgets('menampilkan error dan tombol Retry menjalankan request baru', (tester) async {
    var shouldFail = true;
    final service = FakeExerciseApiService(() async {
      if (shouldFail) {
        throw const ApiException('Koneksi gagal untuk pengujian.');
      }
      return const ExerciseApiResponse(
        exercises: [sampleExercise],
        total: 1,
        hasNextPage: false,
      );
    });

    await tester.pumpWidget(page(service));
    await tester.pumpAndSettle();
    expect(find.text('Gagal Memuat Data Latihan'), findsOneWidget);
    expect(find.text('Coba Lagi (Retry)'), findsOneWidget);

    shouldFail = false;
    await tester.tap(find.text('Coba Lagi (Retry)'));
    await tester.pumpAndSettle();

    expect(find.text('Test Curl'), findsOneWidget);
    expect(service.calls, 2);
  });

  testWidgets('menampilkan tombol Muat Lebih Banyak dan menambahkan latihan baru saat ditekan', (tester) async {
    const secondExercise = ExerciseApiModel(
      exerciseId: 'test-2',
      name: 'hammer curl',
      gifUrl: '',
      bodyParts: ['upper arms'],
      equipments: ['dumbbell'],
      targetMuscles: ['biceps'],
      secondaryMuscles: [],
      instructions: ['Hold and lift.'],
    );

    var fetchCount = 0;
    final service = FakeExerciseApiService(() async {
      fetchCount++;
      if (fetchCount == 1) {
        return const ExerciseApiResponse(
          exercises: [sampleExercise],
          total: 2,
          hasNextPage: true,
          nextCursor: 'cursor-token-2',
        );
      } else {
        return const ExerciseApiResponse(
          exercises: [secondExercise],
          total: 2,
          hasNextPage: false,
          nextCursor: null,
        );
      }
    });

    await tester.pumpWidget(page(service));
    await tester.pumpAndSettle();

    expect(find.text('Test Curl'), findsOneWidget);
    expect(find.textContaining('Muat Lebih Banyak'), findsOneWidget);

    await tester.tap(find.textContaining('Muat Lebih Banyak'));
    await tester.pumpAndSettle();

    expect(find.text('Test Curl'), findsOneWidget);
    expect(find.text('Hammer Curl'), findsOneWidget);
    expect(service.calls, 2);
  });
}
