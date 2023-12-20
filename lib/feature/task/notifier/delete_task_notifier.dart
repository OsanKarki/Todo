import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/repository/todo_repository.dart';


class DeleteTaskNotifier extends StateNotifier<AsyncValue> {
  final TodoRepository _todoRepository;

  DeleteTaskNotifier(this._todoRepository) : super(const AsyncValue.data(null));

  deleteTodo(String id) async {
    state = const AsyncValue.loading();
    final result = await _todoRepository.deleteTodo(id);

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

final deleteTaskRepositoryProvider = Provider<TodoRepository>(
  (ref) => TodoRepository(ref.watch(firebaseFirestoreProvider)),
);

final deleteTaskNotifierProvider =
    StateNotifierProvider<DeleteTaskNotifier, AsyncValue>(
  (ref) => DeleteTaskNotifier(ref.read(deleteTaskRepositoryProvider)),
);

final firebaseFirestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);
