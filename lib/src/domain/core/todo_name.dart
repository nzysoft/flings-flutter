// 📦 Package imports:
import 'package:dominion/dominion.dart';

// 🌎 Project imports:
import 'validation_failure.dart';

/// Represents the name of a [Todo], which cannot be empty.
class TodoName extends ValueObject<ValidationFailure<String>, String> {
  final Either<ValidationFailure<String>, String> value;

  /// Creates and validates a [TodoName]
  factory TodoName(String input) {
    assert(input != null);
    if (input.isEmpty) {
      return TodoName._(left(ValidationFailure.empty(input)));
    } else {
      return TodoName._(right(input));
    }
  }

  TodoName._(this.value);
}
