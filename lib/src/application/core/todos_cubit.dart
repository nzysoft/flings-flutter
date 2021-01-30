// 🎯 Dart imports:
import 'dart:async';

// 📦 Package imports:
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

// 🌎 Project imports:
import '../../domain/core/i_todo_repository.dart';
import '../../domain/core/todo.dart';
import '../../domain/core/todo_name.dart';
import '../../domain/core/unique_id.dart';

/// [Cubit] for working with Todos
class TodosCubit extends Cubit<List<Todo>> {
  final ITodoRepository _repository;

  StreamSubscription<List<Todo>> _subscription;

  /// Creates a new [TodosCubit]
  TodosCubit(this._repository) : super([]) {
    _fetchTodos();
  }

  void _fetchTodos() async {
    await _subscription?.cancel();
    _subscription = _repository.allTodos.listen(emit);
  }

  /// Adds a new [Todo] with the given [name]
  ///
  /// The newly created [Todo] will be initially incomplete.
  void addTodo({@required TodoName name}) {
    _repository.addTodo(
      Todo(id: UniqueId(), name: name, status: TodoStatus.incomplete),
    );
  }

  /// Marks the given [todo] as complete
  void completeTodo(Todo todo) {
    _repository.updateTodo(todo.copyWith(status: TodoStatus.complete));
  }

  /// Marks the given [todo] as cancelled
  void cancelTodo(Todo todo) {
    _repository.updateTodo(todo.copyWith(status: TodoStatus.cancelled));
  }

  /// Marks the given [todo] as incomplete
  void uncompleteTodo(Todo todo) {
    _repository.updateTodo(todo.copyWith(status: TodoStatus.incomplete));
  }

  /// Renames the given [todo] with [name]
  void renameTodo({@required Todo todo, @required TodoName name}) {
    _repository.updateTodo(todo.copyWith(name: name));
  }

  /// Permanently deletes the given [todo]
  void deleteTodo(Todo todo) {
    _repository.deleteTodo(todo);
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    await super.close();
  }
}
