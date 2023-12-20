import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/core/widgets/primary_button.dart';
import 'package:todo_app/core/widgets/secondary_textfield.dart';
import 'package:todo_app/feature/task/model/task.dart';

import '../notifier/add_task_notifier.dart';
import '../notifier/fetch_task_notifier.dart';


@RoutePage()
class TaskAddPage extends ConsumerStatefulWidget {
  const TaskAddPage({Key? key}) : super(key: key);

  @override
  ConsumerState<TaskAddPage> createState() => _TaskAddPageState();
}

class _TaskAddPageState extends ConsumerState<TaskAddPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  late GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(taskAddNotifierProvider, (previous, next) {
      next.map(
        data: (data) {
          context.router.pop();
          ref.read(taskFetchNotifierProvider.notifier).getTodos();
        },
        error: (error) {},
        loading: (loading) {},
      );
    });
    return Scaffold(
      backgroundColor: const Color(0xffdcd0c4),
      appBar: AppBar(
        backgroundColor: const Color(0xff5c5651),
        title: Text(
          "New Task",
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          // Set the desired color here
          onPressed: () {
            context.router.pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SecondaryTextField(
                controller: titleController,
                labelText: "Enter title",
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    return null; // no mistake -> all good
                  } else {
                    return "This field is required";
                  }
                },
              ),
              const SizedBox(
                height: 2,
              ),
              SecondaryTextField(
                controller: descriptionController,
                labelText: "Enter Description",
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    return null; // no mistake -> all good
                  } else {
                    return "This field is required";
                  }
                },
              ),
              const SizedBox(
                height: 30,
              ),
              PrimaryButton(
                text: "Add Task",
                onPressed: () {
                  if (formKey.currentState?.validate() == true) {
                    final todos = Todo(
                        description: descriptionController.text,
                        title: titleController.text,
                        createdTime: DateTime.now());

                    ref.read(taskAddNotifierProvider.notifier).addTodo(todos);
                  }
                },
                buttonColor: Colors.black,
              )
            ],
          ),
        ),
      ),
    );
  }
}
