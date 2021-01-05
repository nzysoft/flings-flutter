// 📦 Package imports:
import 'package:dominion/dominion.dart';
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:flings/src/domain/core/todo_name.dart';
import 'package:flings/src/domain/core/validation_failure.dart';

void main() {
  group('TodoName', () {
    test('passing a null input will throw an exception', () {
      expect(
        () => TodoName(null),
        throwsAssertionError,
      );
    });

    test('passing an empty input will return an invalid TodoName', () {
      final todoName = TodoName('');
      expect(todoName.value, equals(left(ValidationFailure.empty(''))));
      expect(todoName.isValid, isFalse);
    });

    test('passing a valid input returns a valid TodoName', () {
      final todoName = TodoName('name');
      expect(todoName.value, equals(right('name')));
      expect(todoName.isValid, isTrue);
    });
  });
}
