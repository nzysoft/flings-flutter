// 📦 Package imports:
import 'package:dominion/dominion.dart';

// 🌎 Project imports:
import 'todo.dart';
import 'todo_failure.dart';
import 'unique_id.dart';

/// Interface for working with [Todo]s
abstract class ITodoRepository {
  /// Returns the [Todo] with the given [id].
  Future<Either<TodoFailure, Todo>> getTodo(UniqueId id);

  /// Adds a new [todo]
  Future<Either<TodoFailure, Unit>> addTodo(Todo todo);

  /// Updates the given [todo]
  Future<Either<TodoFailure, Unit>> updateTodo(Todo todo);

  /// Deletes the given [todo]
  Future<Either<TodoFailure, Unit>> deleteTodo(Todo todo);

  /// Returns a list of all [Todo]s
  Future<Either<TodoFailure, List<Todo>>> get allTodos;
}
