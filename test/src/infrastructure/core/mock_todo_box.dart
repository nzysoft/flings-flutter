// 📦 Package imports:
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';

// 🌎 Project imports:
import 'package:flings/src/infrastructure/core/todo_model.dart';

class MockTodoBox extends Mock implements Box<TodoModel> {}
