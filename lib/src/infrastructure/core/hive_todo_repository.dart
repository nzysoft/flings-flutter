// 📦 Package imports:
import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

// 🌎 Project imports:
import '../../domain/core/i_todo_repository.dart';
import '../../domain/core/todo.dart';
import '../../domain/core/todo_failure.dart';
import 'todo_model.dart';

/// Implementation of [ITodoRepository] using [Hive]
@singleton
class HiveTodoRepository implements ITodoRepository {
  final Box<TodoModel> _box;

  /// Creates a [HiveTodoRepository]
  const HiveTodoRepository(this._box);

  @override
  Future<Either<TodoFailure, Unit>> addTodo(Todo todo) async {
    if (_box.containsKey(todo.id.value)) {
      return left(TodoFailure.alreadyExists());
    }
    await _box.put(todo.id.value, TodoModel.fromDomain(todo));
    return right(unit);
  }

  @override
  Future<Either<TodoFailure, List<Todo>>> get allTodos async {
    return right(
      _box.toMap().entries.map((e) => e.value.toDomain(e.key)),
    );
  }

  @override
  Future<Either<TodoFailure, Unit>> deleteTodo(Todo todo) async {
    if (!_box.containsKey(todo.id.value)) {
      return left(TodoFailure.doesNotExist());
    }
    await _box.delete(todo.id.value);
    return right(unit);
  }

  @override
  Future<Either<TodoFailure, Unit>> updateTodo(Todo todo) async {
    if (!_box.containsKey(todo.id.value)) {
      return left(TodoFailure.doesNotExist());
    }
    await _box.put(todo.id.value, TodoModel.fromDomain(todo));
    return right(unit);
  }
}
