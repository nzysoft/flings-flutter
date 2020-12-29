// 📦 Package imports:
import 'package:dominion/dominion.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// 🌎 Project imports:
import 'todo_name.dart';
import 'unique_id.dart';

part 'todo.freezed.dart';

/// Represents a Todo
@freezed
abstract class Todo with _$Todo implements Entity<UniqueId> {
  /// Creates a [Todo]
  const factory Todo({
    @required UniqueId id,
    @required TodoName name,
    @required TodoStatus status,
  }) = _Todo;
}

/// Possible statuses for a [Todo]
enum TodoStatus {
  /// The Todo is incomplete
  incomplete,

  /// The Todo is complete
  complete,

  /// The Todo has been cancelled
  cancelled,
}
