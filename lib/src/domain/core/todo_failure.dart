// 📦 Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_failure.freezed.dart';

/// Failures related to operations on Todos
@freezed
abstract class TodoFailure with _$TodoFailure {
  /// An attempt was made to add a Todo that already exists
  const factory TodoFailure.alreadyExists() = _AlreadyExists;

  /// An attempt was made to update or delte a Todo that does not exist;
  const factory TodoFailure.doesNotExist() = _DoesNotExist;
}
