// 📦 Package imports:
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

// 🌎 Project imports:
import '../../domain/core/todo.dart';
import '../../domain/core/todo_name.dart';
import '../../domain/core/unique_id.dart';

part 'todo_model.g.dart';

/// Model for storing Todos in [Hive]
@immutable
@HiveType(typeId: 0)
class TodoModel {
  /// The todo name
  @HiveField(1)
  final String name;

  /// The status of the todo
  ///
  /// 0: incomplete
  /// 1: complete
  /// -1: cancelled
  @HiveField(2)
  final int status;

  /// Creates a [TodoModel]
  TodoModel({
    @required this.name,
    @required this.status,
  }) : assert(status >= -1 && status <= 1);

  /// Converts this to a [Todo].
  Todo toDomain(String id) {
    TodoStatus domainStatus;
    switch (status) {
      case 0:
        domainStatus = TodoStatus.incomplete;
        break;
      case 1:
        domainStatus = TodoStatus.complete;
        break;
      case -1:
        domainStatus = TodoStatus.cancelled;
        break;
    }
    return Todo(
      id: UniqueId.fromInfrastructure(id),
      name: TodoName(name),
      status: domainStatus,
    );
  }

  /// Converts a [Todo] into a [TodoModel]
  factory TodoModel.fromDomain(Todo todo) {
    int modelStatus;
    switch (todo.status) {
      case TodoStatus.complete:
        modelStatus = 1;
        break;
      case TodoStatus.incomplete:
        modelStatus = 0;
        break;
      case TodoStatus.cancelled:
        modelStatus = -1;
        break;
    }
    return TodoModel(
      name: todo.name.getOrCrash(),
      status: modelStatus,
    );
  }

  @override
  String toString() => 'TodoModel(name: $name, status: $status)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is TodoModel && o.name == name && o.status == status;
  }

  @override
  int get hashCode => name.hashCode ^ status.hashCode;
}
