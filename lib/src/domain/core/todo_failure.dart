// 📦 Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_failure.freezed.dart';

/// Failures related to operations on Todos
@freezed
abstract class TodoFailure with _$TodoFailure {
  /// A attempt was made to add or update a Todo that already exists
  const factory TodoFailure.alreadyExists() = _AlreadyExists;
}
