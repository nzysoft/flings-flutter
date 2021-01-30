// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// 🌎 Project imports:
import 'package:flings/src/domain/core/todo.dart';
import 'package:flings/src/domain/core/todo_name.dart';
import 'package:flings/src/domain/core/unique_id.dart';
import 'package:flings/src/infrastructure/core/errors.dart';
import 'package:flings/src/infrastructure/core/hive_todo_repository.dart';
import 'package:flings/src/infrastructure/core/todo_model.dart';
import 'mock_todo_box.dart';

void main() {
  group('HiveTodoRepository', () {
    MockTodoBox box;
    HiveTodoRepository repository;

    setUp(() {
      box = MockTodoBox();
      repository = HiveTodoRepository(box);
    });

    group('getTodo', () {
      test('throws an error if the todo does not exist', () {
        const id = 'id';
        when(box.containsKey(id)).thenReturn(false);

        expect(
          () => repository.getTodo(UniqueId.fromInfrastructure(id)),
          throwsA(isA<DoesNotExistError>()),
        );
      });

      test('returns the todo if it does exist', () {
        const id = 'id';
        when(box.containsKey(id)).thenReturn(true);
        final tTodo = Todo(
          id: UniqueId.fromInfrastructure(id),
          name: TodoName('name'),
          status: TodoStatus.incomplete,
        );

        when(box.get('id')).thenReturn(TodoModel(name: 'name', status: 0));

        expect(
          repository.getTodo(UniqueId.fromInfrastructure(id)),
          equals(tTodo),
        );
      });
    });

    group('addTodo', () {
      test('throws an error if the todo already exists', () {
        const id = 'id';
        when(box.containsKey(id)).thenReturn(true);
        final tTodo = Todo(
          id: UniqueId.fromInfrastructure(id),
          name: TodoName('name'),
          status: TodoStatus.incomplete,
        );

        expect(
          () => repository.addTodo(tTodo),
          throwsA(isA<AlreadyExistsError>()),
        );

        verifyNever(box.put(id, TodoModel.fromDomain(tTodo)));
      });

      test('succeeds when the todo does not already exist', () {
        const id = 'id';
        when(box.containsKey(id)).thenReturn(false);
        final tTodo = Todo(
          id: UniqueId.fromInfrastructure(id),
          name: TodoName('name'),
          status: TodoStatus.incomplete,
        );

        repository.addTodo(tTodo);

        verify(box.put(id, TodoModel.fromDomain(tTodo)));
      });
    });

    group('deleteTodo', () {
      test('deleting a todo that does not exist throws an error', () {
        const id = 'id';
        when(box.containsKey(id)).thenReturn(false);

        final tTodo = Todo(
          id: UniqueId.fromInfrastructure(id),
          name: TodoName('name'),
          status: TodoStatus.incomplete,
        );

        expect(
          () => repository.deleteTodo(tTodo),
          throwsA(isA<DoesNotExistError>()),
        );

        verifyNever(box.delete(id));
      });

      test('deleting a todo that does exist completes successfully', () {
        const id = 'id';
        when(box.containsKey(id)).thenReturn(true);

        final tTodo = Todo(
          id: UniqueId.fromInfrastructure(id),
          name: TodoName('name'),
          status: TodoStatus.incomplete,
        );

        repository.deleteTodo(tTodo);

        verify(box.delete(id));
      });
    });

    group('updateTodo', () {
      test('updating a todo that does not exist returns an error', () {
        const id = 'id';
        when(box.containsKey(id)).thenReturn(false);

        final tTodo = Todo(
          id: UniqueId.fromInfrastructure(id),
          name: TodoName('name'),
          status: TodoStatus.incomplete,
        );

        expect(
          () => repository.updateTodo(tTodo),
          throwsA(isA<DoesNotExistError>()),
        );

        verifyNever(box.put(id, TodoModel.fromDomain(tTodo)));
      });

      test('updating a todo that does exist completes successfully', () {
        const id = 'id';
        when(box.containsKey(id)).thenReturn(true);

        final tTodo = Todo(
          id: UniqueId.fromInfrastructure(id),
          name: TodoName('name'),
          status: TodoStatus.incomplete,
        );

        repository.updateTodo(tTodo);

        verify(box.put(id, TodoModel.fromDomain(tTodo)));
      });
    });
  });
}
