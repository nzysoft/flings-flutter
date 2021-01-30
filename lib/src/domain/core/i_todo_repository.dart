// 🌎 Project imports:
import 'todo.dart';
import 'unique_id.dart';

/// Interface for working with [Todo]s
abstract class ITodoRepository {
  /// Returns the [Todo] with the given [id].
  Todo getTodo(UniqueId id);

  /// Adds a new [todo]
  void addTodo(Todo todo);

  /// Updates the given [todo]
  void updateTodo(Todo todo);

  /// Deletes the given [todo]
  void deleteTodo(Todo todo);

  /// Returns a list of all [Todo]s
  Stream<List<Todo>> get allTodos;
}
