// 📦 Package imports:
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

/// Represents an ID which is guaranteed to be unique
@immutable
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

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is UniqueId && o.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
