// 📦 Package imports:
import 'package:dominion/dominion.dart';
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:flings/src/domain/core/todo.dart';
import 'package:flings/src/domain/core/todo_name.dart';
import 'package:flings/src/domain/core/unique_id.dart';
import 'package:flings/src/infrastructure/core/todo_model.dart';

void main() {
  group('TodoModel', () {
    group('constuctor', () {
      test('valid statuses do not throw assertion error', () {
        expect(
          () => TodoModel(name: 'name', status: 0),
          returnsNormally,
        );
        expect(
          () => TodoModel(name: 'name', status: -1),
          returnsNormally,
        );
        expect(
          () => TodoModel(name: 'name', status: 1),
          returnsNormally,
        );
      });

      test('invalid status throw assertion error', () {
        expect(
          () => TodoModel(name: 'name', status: -2),
          throwsAssertionError,
        );
        expect(
          () => TodoModel(name: 'name', status: 2),
          throwsAssertionError,
        );
      });
    });

    group('toDomain', () {
      test('returns correct Todo with incomplete status', () {
        final tModel = TodoModel(name: 'name', status: 0);
        final tId = 'abcd';
        final tTodo = Todo(
          id: UniqueId.fromInfrastructure(tId),
          name: TodoName('name'),
          status: TodoStatus.incomplete,
        );
        expect(
          tModel.toDomain('abcd'),
          equals(tTodo),
        );
      });

      test('returns correct Todo with complete status', () {
        final tModel = TodoModel(name: 'name', status: 1);
        final tId = 'abcd';
        final tTodo = Todo(
          id: UniqueId.fromInfrastructure(tId),
          name: TodoName('name'),
          status: TodoStatus.complete,
        );
        expect(
          tModel.toDomain('abcd'),
          equals(tTodo),
        );
      });

      test('returns correct Todo with cancelled status', () {
        final tModel = TodoModel(name: 'name', status: -1);
        final tId = 'abcd';
        final tTodo = Todo(
          id: UniqueId.fromInfrastructure(tId),
          name: TodoName('name'),
          status: TodoStatus.cancelled,
        );
        expect(
          tModel.toDomain('abcd'),
          equals(tTodo),
        );
      });
    });

    group('fromDomain', () {
      test('returns correct TodoModel with valid input', () {
        final tModel = TodoModel(name: 'name', status: -1);
        final tId = 'abcd';
        final tTodo = Todo(
          id: UniqueId.fromInfrastructure(tId),
          name: TodoName('name'),
          status: TodoStatus.cancelled,
        );
        expect(
          TodoModel.fromDomain(tTodo),
          equals(tModel),
        );
      });

      test('throws UnexpectedValueError with invalid name', () {
        final tTodo = Todo(
          id: UniqueId.fromInfrastructure('abcd'),
          name: TodoName(''),
          status: TodoStatus.cancelled,
        );
        expect(
          () => TodoModel.fromDomain(tTodo),
          throwsA(isA<UnexpectedValueError>()),
        );
      });
    });
  });
}
