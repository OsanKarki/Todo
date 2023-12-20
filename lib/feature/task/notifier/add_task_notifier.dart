import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/feature/task/model/task.dart';

import '../data/repository/todo_repository.dart';

class AddTaskNotifier extends StateNotifier<AsyncValue> {
  final TodoRepository _todoRepository;

  AddTaskNotifier(this._todoRepository) : super(const AsyncValue.data(null));

  addTodo(Todo todos) async {
    state = AsyncValue.loading();
    final result = await _todoRepository.addTodo(todos);

    result.fold(
      (l) {
        state = AsyncValue.error(l, StackTrace.current);
      },
      (r) {
        state = AsyncValue.data(r);
      },
    );
  }
}

final taskRepositoryProvider = Provider<TodoRepository>(
  (ref) => TodoRepository(ref.watch(firebaseFirestoreProvider)),
);

final taskAddNotifierProvider =
    StateNotifierProvider<AddTaskNotifier, AsyncValue>(
  (ref) => AddTaskNotifier(ref.read(taskRepositoryProvider)),
);

final firebaseFirestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);
