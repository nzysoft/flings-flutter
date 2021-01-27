part of 'todos_bloc.dart';

/// States for [TodosBloc]
@freezed
abstract class TodosState with _$TodosState {
  /// Loading todos
  const factory TodosState.loading() = _Loading;

  /// Success state containing all [todos]
  const factory TodosState.success({
    @required List<Todo> todos,
  }) = _Success;

  /// Failure state
  const factory TodosState.failure({
    @required TodoFailure failure,
  }) = _Failure;
}
