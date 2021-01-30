// 📦 Package imports:
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

// 🌎 Project imports:
import '../../domain/core/i_todo_repository.dart';
import '../../domain/core/todo.dart';
import '../../domain/core/unique_id.dart';
import 'errors.dart';
import 'todo_model.dart';

/// Implementation of [ITodoRepository] using [Hive]
@singleton
class HiveTodoRepository implements ITodoRepository {
  final Box<TodoModel> _box;

  /// Creates a [HiveTodoRepository]
  const HiveTodoRepository(this._box);

  @override
  Todo getTodo(UniqueId id) {
    if (!_box.containsKey(id.value)) {
      throw DoesNotExistError();
    }
    return _box.get(id.value).toDomain(id.value);
  }

  @override
  void addTodo(Todo todo) {
    if (_box.containsKey(todo.id.value)) {
      throw AlreadyExistsError();
    }
    _box.put(todo.id.value, TodoModel.fromDomain(todo));
  }

  @override
  Stream<List<Todo>> get allTodos {
    return _box.watch().map(
          (_) => _box
              .toMap()
              .entries
              .map(
                (e) => e.value.toDomain(e.key),
              )
              .toList(),
        );
  }

  @override
  void deleteTodo(Todo todo) {
    if (!_box.containsKey(todo.id.value)) {
      throw DoesNotExistError();
    }
    _box.delete(todo.id.value);
  }

  @override
  void updateTodo(Todo todo) {
    if (!_box.containsKey(todo.id.value)) {
      throw DoesNotExistError();
    }
    _box.put(todo.id.value, TodoModel.fromDomain(todo));
  }
}
