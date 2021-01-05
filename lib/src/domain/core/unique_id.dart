// 📦 Package imports:
import 'package:uuid/uuid.dart';

/// Represents an ID which is guaranteed to be unique
class UniqueId {
  /// The underlying ID
  final String value;

  /// Creates a [UniqueId].
  factory UniqueId() {
    return UniqueId._(Uuid().v1());
  }

  /// Creates a [UniqueId] from an [input] which we already know is unique.
  factory UniqueId.fromInfrastructure(String input) {
    return UniqueId._(input);
  }

  UniqueId._(this.value);
}
