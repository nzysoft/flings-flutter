part of 'todos_bloc.dart';

/// Events for the [TodosBloc]
@freezed
abstract class TodosEvent with _$TodosEvent {
  /// Refresh the current todo list
  const factory TodosEvent.fetchTodos() = _FetchTodos;

  /// Create a new [Todo] with the given [name]
  const factory TodosEvent.addTodo({@required TodoName name}) = _AddTodo;

  /// Updates the [Todo] with [id] using the provided [name]
  const factory TodosEvent.renameTodo({
    @required UniqueId id,
    @required TodoName name,
  }) = _UpdateTodo;

  /// Completes the [Todo] with the given [id]
  const factory TodosEvent.completeTodo({
    @required UniqueId id,
  }) = _CompleteTodo;

  /// Cancels the [Todo] with the given [id]
  const factory TodosEvent.cancelTodo({
    @required UniqueId id,
  }) = _CancelTodo;

  /// Uncompletes the [Todo] with the given [id]
  const factory TodosEvent.uncompleteTodo({
    @required UniqueId id,
  }) = _UncompleteTodo;

  /// Deletes the [Todo] with the given [id]
  const factory TodosEvent.deleteTodo({
    @required UniqueId id,
  }) = _DeleteTodo;
}
