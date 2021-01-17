// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';

// 📦 Package imports:
import 'package:dominion/dominion.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// 🌎 Project imports:
import 'package:flings/src/domain/core/todo.dart';
import 'package:flings/src/domain/core/todo_failure.dart';
import 'package:flings/src/domain/core/todo_name.dart';
import 'package:flings/src/domain/core/unique_id.dart';
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

    group('addTodo', () {
      test('returns an error if the todo already exists', () async {
        const id = 'id';
        when(box.containsKey(id)).thenReturn(true);
        final tTodo = Todo(
          id: UniqueId.fromInfrastructure(id),
          name: TodoName('name'),
          status: TodoStatus.incomplete,
        );

        expect(
          await repository.addTodo(tTodo),
          equals(Left<TodoFailure, Unit>(TodoFailure.alreadyExists())),
        );

        verifyNever(box.put(id, TodoModel.fromDomain(tTodo)));
      });

      test('succeeds when the todo does not already exist', () async {
        const id = 'id';
        when(box.containsKey(id)).thenReturn(false);
        final tTodo = Todo(
          id: UniqueId.fromInfrastructure(id),
          name: TodoName('name'),
          status: TodoStatus.incomplete,
        );

        expect(
          await repository.addTodo(tTodo),
          equals(Right<TodoFailure, Unit>(unit)),
        );

        verify(box.put(id, TodoModel.fromDomain(tTodo)));
      });
    });

    group('allTodos', () {
      test('returns todos successfully', () async {
        final tModels = <String, TodoModel>{
          'id': TodoModel(name: 'name', status: 0),
        };
        when(box.toMap()).thenReturn(tModels);

        final expected = <Todo>[
          Todo(
            id: UniqueId.fromInfrastructure('id'),
            name: TodoName('name'),
            status: TodoStatus.incomplete,
          ),
        ];

        final result = await repository.allTodos;

        expect(result, isA<Right<TodoFailure, List<Todo>>>());

        expect(
          listEquals(
            (result as Right<TodoFailure, List<Todo>>).value,
            expected,
          ),
          isTrue,
        );

        verify(box.toMap());
      });
    });

    group('deleteTodo', () {
      test('deleting a todo that does not exist returns an error', () async {
        const id = 'id';
        when(box.containsKey(id)).thenReturn(false);

        final tTodo = Todo(
          id: UniqueId.fromInfrastructure(id),
          name: TodoName('name'),
          status: TodoStatus.incomplete,
        );

        expect(
          await repository.deleteTodo(tTodo),
          equals(Left<TodoFailure, Unit>(TodoFailure.doesNotExist())),
        );

        verifyNever(box.delete(id));
      });

      test(
        'deleting a todo that does exist completes successfully',
        () async {
          const id = 'id';
          when(box.containsKey(id)).thenReturn(true);

          final tTodo = Todo(
            id: UniqueId.fromInfrastructure(id),
            name: TodoName('name'),
            status: TodoStatus.incomplete,
          );

          expect(
            await repository.deleteTodo(tTodo),
            equals(Right<TodoFailure, Unit>(unit)),
          );

          verify(box.delete(id));
        },
      );
    });

    group('updateTodo', () {
      test('updating a todo that does not exist returns an error', () async {
        const id = 'id';
        when(box.containsKey(id)).thenReturn(false);

        final tTodo = Todo(
          id: UniqueId.fromInfrastructure(id),
          name: TodoName('name'),
          status: TodoStatus.incomplete,
        );

        expect(
          await repository.updateTodo(tTodo),
          equals(Left<TodoFailure, Unit>(TodoFailure.doesNotExist())),
        );

        verifyNever(box.put(id, TodoModel.fromDomain(tTodo)));
      });

      test(
        'updating a todo that does exist completes successfully',
        () async {
          const id = 'id';
          when(box.containsKey(id)).thenReturn(true);

          final tTodo = Todo(
            id: UniqueId.fromInfrastructure(id),
            name: TodoName('name'),
            status: TodoStatus.incomplete,
          );

          expect(
            await repository.updateTodo(tTodo),
            equals(Right<TodoFailure, Unit>(unit)),
          );

          verify(box.put(id, TodoModel.fromDomain(tTodo)));
        },
      );
    });
  });
}
