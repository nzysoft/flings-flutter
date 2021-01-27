// 📦 Package imports:
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// 🌎 Project imports:
import '../../../domain/core/i_todo_repository.dart';
import '../../../domain/core/todo.dart';
import '../../../domain/core/todo_failure.dart';
import '../../../domain/core/todo_name.dart';
import '../../../domain/core/unique_id.dart';

part 'todos_bloc.freezed.dart';
part 'todos_event.dart';
part 'todos_state.dart';

/// [Bloc] for working with [Todo]s
class TodosBloc extends Bloc<TodosEvent, TodosState> {
  final ITodoRepository _repository;

  /// Creates a [TodosBloc]
  TodosBloc(this._repository) : super(TodosState.loading());

  @override
  Stream<TodosState> mapEventToState(TodosEvent event) async* {
    yield* event.when<Stream<TodosState>>(
      fetchTodos: () async* {
        yield await _fetchTodos();
      },
      addTodo: (name) async* {
        await _repository.addTodo(
          Todo(
            id: UniqueId(),
            name: name,
            status: TodoStatus.incomplete,
          ),
        );
        yield await _fetchTodos();
      },
      renameTodo: (id, name) async* {
        final todoResult = await _repository.getTodo(id);
        yield* todoResult.fold(
          (f) => throw f,
          (todo) async* {
            await _repository.updateTodo(
              todo.copyWith(name: name),
            );
            yield await _fetchTodos();
          },
        );
      },
      completeTodo: (id) async* {
        final todoResult = await _repository.getTodo(id);
        yield* todoResult.fold(
          (f) => throw f,
          (todo) async* {
            await _repository.updateTodo(
              todo.copyWith(status: TodoStatus.complete),
            );
            yield await _fetchTodos();
          },
        );
      },
      cancelTodo: (id) async* {
        final todoResult = await _repository.getTodo(id);
        yield* todoResult.fold(
          (f) => throw f,
          (todo) async* {
            await _repository.updateTodo(
              todo.copyWith(status: TodoStatus.cancelled),
            );
            yield await _fetchTodos();
          },
        );
      },
      uncompleteTodo: (id) async* {
        final todoResult = await _repository.getTodo(id);
        yield* todoResult.fold(
          (f) => throw f,
          (todo) async* {
            await _repository.updateTodo(
              todo.copyWith(status: TodoStatus.cancelled),
            );
            yield await _fetchTodos();
          },
        );
      },
      deleteTodo: (id) async* {
        final todoResult = await _repository.getTodo(id);
        yield* todoResult.fold(
          (f) => throw f,
          (todo) async* {
            await _repository.deleteTodo(todo);
            yield await _fetchTodos();
          },
        );
      },
    );
  }

  Future<TodosState> _fetchTodos() async {
    final result = await _repository.allTodos;
    return result.fold(
      (f) => TodosState.failure(failure: f),
      (todos) => TodosState.success(todos: todos),
    );
  }
}
