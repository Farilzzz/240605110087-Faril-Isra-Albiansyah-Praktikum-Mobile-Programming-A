import 'package:flutter_test/flutter_test.dart';
import 'package:gym_app/model/exercise_api_model.dart';

void main() {
  group('ExerciseApiModel', () {
    test('mem-parsing struktur JSON aktual ExerciseDB', () {
      final model = ExerciseApiModel.fromJson({
        'exerciseId': '01qpYSe',
        'name': 'upward facing dog',
        'gifUrl': 'https://static.exercisedb.dev/media/01qpYSe.gif',
        'bodyParts': ['back'],
        'equipments': ['bodyweight'],
        'targetMuscles': ['erector spinae'],
        'secondaryMuscles': ['deltoids', 'pectorals'],
        'instructions': ['Step:1 Position yourself face down.'],
      });

      expect(model.exerciseId, '01qpYSe');
      expect(model.formattedName, 'Upward Facing Dog');
      expect(model.gifUrl, endsWith('/01qpYSe.gif'));
      expect(model.bodyParts, ['back']);
      expect(model.primaryTarget, 'Erector spinae');
      expect(model.instructions, hasLength(1));
    });

    test('field opsional yang tidak ada menghasilkan nilai aman', () {
      final model = ExerciseApiModel.fromJson(const {});

      expect(model.exerciseId, isEmpty);
      expect(model.name, 'Unnamed Exercise');
      expect(model.gifUrl, isEmpty);
      expect(model.bodyParts, isEmpty);
      expect(model.instructions, isEmpty);
    });
  });
}
