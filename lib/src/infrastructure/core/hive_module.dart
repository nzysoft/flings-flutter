// 📦 Package imports:
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

// 🌎 Project imports:
import 'todo_model.dart';

/// Dependencies related to [Hive]
@module
abstract class HiveModule {
  /// [Box] for storing [TodoModel]s
  @singleton
  Box<TodoModel> get todosBox {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TodoModelAdapter());
    }
    if (!Hive.isBoxOpen('todos')) {
      Hive.openBox('todos');
    }
    return Hive.box('todos');
  }
}
