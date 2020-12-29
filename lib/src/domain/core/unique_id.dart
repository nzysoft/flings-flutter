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

  UniqueId._(this.value);
}
