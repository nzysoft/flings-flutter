// 📦 Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'validation_failure.freezed.dart';

/// Possible validation failures
@freezed
abstract class ValidationFailure<T> with _$ValidationFailure<T> {
  /// The [failedValue] cannot be empty, but was
  const factory ValidationFailure.empty(T failedValue) = _Empty;
}
