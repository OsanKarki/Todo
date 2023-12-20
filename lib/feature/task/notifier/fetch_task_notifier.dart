import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/repository/todo_repository.dart';

class FetchTaskNotifier extends StateNotifier<AsyncValue> {
  final TodoRepository _todoRepository;

  FetchTaskNotifier(this._todoRepository) : super(const AsyncLoading()) {
    getTodos();
  }

  getTodos() async {
    final result = await _todoRepository.getTodos();
    result.fold(
      (l) {
        state = AsyncError(l, StackTrace.current);
      },
      (r) {
        state = AsyncData(r);
      },
    );
  }
}

final taskRepositoryProvider = Provider<TodoRepository>(
  (ref) => TodoRepository(ref.watch(firebaseFirestoreProvider)),
);
final taskFetchNotifierProvider =
    StateNotifierProvider.autoDispose<FetchTaskNotifier, AsyncValue>(
  (ref) => FetchTaskNotifier(ref.watch(taskRepositoryProvider)),
);

final firebaseFirestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);
