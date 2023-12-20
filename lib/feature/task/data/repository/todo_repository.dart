import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../model/task.dart';

class TodoRepository {
  final FirebaseFirestore firebaseFirestore;
  int perPageLimit = 10;


  TodoRepository(this.firebaseFirestore);

  Future<Either<NetworkException, List<Todo>>> getTodos() async {

    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection("todos")
              .orderBy('createdTime', descending: true)
              .limit(perPageLimit)
              .get();
      final taskList = snapshot.docs
          .map((e) => Todo.fromJson(e.data()).copyWith(id: e.id))
          .toList();
      return right(taskList);
    } catch (e) {
      if (e is SocketException) {
        return left(NetworkException("No Internet Connection"));
      } else {
        return left(NetworkException(e.toString()));
      }
    }
  }
  Future<Either<NetworkException, List<Todo>>> getMoreTodos() async {

    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection("todos")
              .orderBy('createdTime', descending: true)
              .limit(perPageLimit)
              .get();
      final taskList = snapshot.docs
          .map((e) => Todo.fromJson(e.data()).copyWith(id: e.id))
          .toList();
      return right(taskList);
    } catch (e) {
      if (e is SocketException) {
        return left(NetworkException("No Internet Connection"));
      } else {
        return left(NetworkException(e.toString()));
      }
    }
  }

  Future<Either<NetworkException, String>> deleteTodo(String id) async {
    try {
      FirebaseFirestore.instance.collection("todos").doc(id).delete();
      return right("deleted");
    } catch (e) {
      if (e is SocketException) {
        return left(NetworkException("No Internet Connection"));
      } else {
        return left(NetworkException(e.toString()));
      }
    }
  }

  Future<Either<NetworkException, String>> addTodo(Todo newTask) async {
    try {
      await FirebaseFirestore.instance
          .collection("todos")
          .add(newTask.toJson());
      return right("Task added successfully");
    } catch (e) {
      if (e is SocketException) {
        return left(NetworkException("No Internet Connection"));
      } else {
        return left(NetworkException(e.toString()));
      }
    }
  }
}

class NetworkException {
  String value;

  NetworkException(this.value);
}
