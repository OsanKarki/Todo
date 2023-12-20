import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart'; // Import the pull_to_refresh package
import 'package:todo_app/core/routes/app_routes.gr.dart';
import '../../task/data/repository/todo_repository.dart';
import '../../task/model/task.dart';
import '../../task/notifier/delete_task_notifier.dart';
import '../../task/notifier/fetch_task_notifier.dart';

@RoutePage()
class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref){
    final first = FirebaseFirestore.instance.collection("todos").limit(10);
    ref.listen(deleteTaskNotifierProvider, (previous, next) {
      next.map(
        data: (value) {
          ref.read(taskFetchNotifierProvider.notifier).getTodos();
        },
        error: (value) {},
        loading: (value) {},
      );
    });
    final taskState = ref.watch(taskFetchNotifierProvider);
    return Scaffold(
      backgroundColor: const Color(0xffdcd0c4),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.router.push(const TaskAddRoute());
        },
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xff5c5651),
        title: Text(
          "TODO'S",
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Colors.white),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          taskState.map(
            data: (data) {
              final List<Todo> tasks = data.value;
              return tasks.isEmpty
                  ? Center(
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/png/Todo.png",
                            height: 10,
                          ),
                          Text(
                            'No tasks available.',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    )
                  : Expanded(
                      child: SmartRefresher(
                        controller: RefreshController(),
                        enablePullDown: false,
                        enablePullUp: true,
                        onRefresh: () async {
                          // first.get().then(
                          //   (value) {
                          //     final lastVisible = value.docs[value.size - 1];
                          //
                          //     final next = FirebaseFirestore.instance
                          //         .collection("todos")
                          //         .orderBy("id")
                          //         .startAfterDocument(lastVisible)
                          //         .limit(10);
                          //   },
                          //   onError: (e) => print("Error completing: $e"),
                          // );
                          await Future.delayed(const Duration(
                              seconds: 2)); // Simulate a refresh delay
                          ref
                              .read(taskFetchNotifierProvider.notifier)
                              .getTodos();
                        },
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final Todo task = tasks[index];
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.black45,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          task.title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(color: Colors.white),
                                        ),
                                        Text(
                                          DateFormat('d MMM, yyyy')
                                              .format(task.createdTime),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 340,
                                          child: Text(
                                            task.description,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(color: Colors.white),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            ref
                                                .read(deleteTaskNotifierProvider
                                                    .notifier)
                                                .deleteTodo("${task.id}");
                                          },
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
            },
            error: (error) {
              return Text("Error: ${(error.error as NetworkException).value}");
            },
            loading: (loading) {
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }
}
