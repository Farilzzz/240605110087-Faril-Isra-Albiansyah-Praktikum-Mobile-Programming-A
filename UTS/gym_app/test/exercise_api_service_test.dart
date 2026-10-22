import 'package:flutter_test/flutter_test.dart';
import 'package:gym_app/service/exercise_api_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('ExerciseApiService', () {
    test('mengolah respons HTTP 200 menjadi model Dart', () async {
      final client = MockClient((request) async {
        expect(request.url.path, '/api/v1/exercises');
        expect(request.url.queryParameters['limit'], '20');
        return http.Response(
          '''{"success":true,"meta":{"total":1,"hasNextPage":false,"hasPreviousPage":false,"nextCursor":null},"data":[{"exerciseId":"01qpYSe","name":"upward facing dog","gifUrl":"https://static.exercisedb.dev/media/01qpYSe.gif","bodyParts":["back"],"equipments":["bodyweight"],"targetMuscles":["erector spinae"],"secondaryMuscles":["deltoids"],"instructions":["Step:1 Start position"]}]}''',
          200,
          headers: {'content-type': 'application/json'},
        );
      });
      final service = ExerciseApiService(client: client);

      final result = await service.fetchExercises();

      expect(result.total, 1);
      expect(result.hasNextPage, isFalse);
      expect(result.exercises.single.exerciseId, '01qpYSe');
      service.dispose();
    });

    test('melempar ApiException untuk status HTTP selain sukses', () async {
      final service = ExerciseApiService(
        client: MockClient((_) async => http.Response('server error', 503)),
      );

      await expectLater(
        service.fetchExercises(),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'statusCode', 503)),
      );
      service.dispose();
    });

    test('menolak struktur JSON yang tidak sesuai', () async {
      final service = ExerciseApiService(
        client: MockClient((_) async => http.Response('{"success":true,"data":{}}', 200)),
      );

      await expectLater(service.fetchExercises(), throwsA(isA<ApiException>()));
      service.dispose();
    });
  });
}
