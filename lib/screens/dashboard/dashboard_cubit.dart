
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:team_finder/firebase/firestore.dart';
import 'package:team_finder/models/team_card_model.dart';
import 'package:team_finder/models/todo_model.dart';
import 'package:team_finder/shared/input_dialog.dart';
import 'package:team_finder/shared/user_data.dart';


class DashboardState {
  List<TodoModel> todos;
  List<TodoModel> doing;
  List<TodoModel> done;
  bool isLoading;

  DashboardState({
    this.todos = const [],
    this.doing = const [],
    this.done = const [],
    this.isLoading = false
  });

  DashboardState clone() => DashboardState(
    todos: todos,
    doing: doing,
    done: done
  );
}


class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(): super(DashboardState());
  late TeamCardModel teamModel;

  void setInitial(TeamCardModel teamModel) {
    this.teamModel = teamModel;
    getAllTodos();
  }

  void addTodo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return InputDialog(
          title: "ADD TODO",
          hint: "Add new TODO",
          multiLine: true,
          prefix: Icon(Icons.task_alt, color: Colors.cyan[700], size: 30),
          onConfirm: (String content) async {
            String todoContent = content.trim();
            if (todoContent.isEmpty) {
              Fluttertoast.showToast(msg: "No todo entered");
              return false;
            }

            TodoModel todoModel = TodoModel(
              id: "",
              content: todoContent,
              userId: UserData.uid,
              timestamp: Timestamp.now().millisecondsSinceEpoch
            );

            String id = await Firestore.postTodo(teamId: teamModel.id, todo: todoModel);
            todoModel.id = id;
            state.todos = [...state.todos, todoModel];
            emit(state.clone());
            return true;
          },
        );
      }
    );
  }

  Future<void> getAllTodos() async {
    List<TodoModel> todos = await Firestore.getAllTodos(teamId: teamModel.id);
    emit(DashboardState(isLoading: true));

    List<TodoModel> todoList = [];
    List<TodoModel> doing = [];
    List<TodoModel> done = [];

    for (TodoModel todo in todos) {
      if (todo.todoCase == 0) { todoList.add(todo);}
      else if (todo.todoCase == 1) { doing.add(todo); }
      else { done.add(todo); }
    }

    emit(DashboardState(
      todos: todoList,
      doing: doing,
      done: done
    ));
  }
}
