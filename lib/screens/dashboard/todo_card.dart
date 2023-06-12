
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:team_finder/firebase/firestore.dart';
import 'package:team_finder/models/todo_model.dart';
import 'package:team_finder/screens/dashboard/dashboard_cubit.dart';
import 'package:team_finder/shared/input_dialog.dart';
import 'package:team_finder/shared/loading_box.dart';
import 'package:team_finder/shared/shared_functions.dart';
import 'package:team_finder/shared_widgets/edited_container.dart';
import 'package:team_finder/shared_widgets/user_from_id.dart';


class TodoCard extends StatelessWidget {
  final TodoModel todoModel;
  final String teamId;
  const TodoCard({Key? key, required this.todoModel, required this.teamId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TodoCubit cubit = TodoCubit(todoModel, teamId);

    return BlocProvider<TodoCubit>(
      create: (context) => cubit,
      child: EditedContainer(
        width: 300,
        height: 160,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        shadowColor: Colors.grey,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: InkWell(
                onTap: () => cubit.showAllContent(context),
                child: Text(
                  todoModel.content,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
            ),

            const Divider(thickness: 2, color: Colors.grey),

            Text(
              "CREATED IN: ${getDate(todoModel.timestamp)}",
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.purple
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: UserFromId(
                    userId: todoModel.userId,
                    marginLeft: 0,
                    cardWidth: 180,
                    cardHeight: 40,
                  ),
                ),

                InkWell(
                  onTap: () => cubit.settings(context),
                  child: const Icon(Icons.settings, color: Colors.cyan)
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}


class TodoCubit extends Cubit<TodoModel> {
  TodoCubit(TodoModel todoModel, this.teamId): super(todoModel);
  final String teamId;
  // final DashboardCubit dashboardCubit;

  void showAllContent(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return InfoDialog(content: state.content);
      }
    );
  }

  void settings(BuildContext context) {
    TodoSetting(context, state, teamId).showDialogSettings();
  }
}




class InfoDialog extends StatelessWidget {
  final String content;
  const InfoDialog({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.symmetric(vertical: 70),
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))
      ),

      content: EditedContainer(
        width: width - 80,
        height: 200,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "TODO CONTENT",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 19
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),

                children: [
                  Text(
                    content,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


class TodoSetting {
  BuildContext context;
  TodoModel todoModel;
  String teamId;
  TodoSetting(this.context, this.todoModel, this.teamId) {
    dashboardCubit = BlocProvider.of<DashboardCubit>(context);
  }


  late final DashboardCubit dashboardCubit;
  List<String> labels = ["TODO", "DOING", "DONE"];

  Widget listItem(int from, int to) {
    if (to == from) return const SizedBox();

    return ListTile(
      title: Text(
        "Move to ${labels[to]}",
        style: const TextStyle(fontWeight: FontWeight.w600)
      ),
      leading: Icon(from < to? Icons.move_down: Icons.move_up, color: Colors.cyan[700]),
      onTap: () => changeCaseTo(to),
    );
  }

  void showDialogSettings() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          insetPadding: const EdgeInsets.symmetric(vertical: 70),
          clipBehavior: Clip.antiAlias,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))
          ),

          content: EditedContainer(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Center(
                  child: Text(
                    "TODO SETTINGS",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                for (int i = 0; i < 3; i++) listItem(todoModel.todoCase, i),

                ListTile(
                  title: const Text(
                    "Edit",
                    style: TextStyle(fontWeight: FontWeight.w600)
                  ),
                  leading: Icon(Icons.edit, color: Colors.cyan[700]),
                  onTap: edit,
                ),

                ListTile(
                  title: const Text(
                    "Delete",
                    style: TextStyle(fontWeight: FontWeight.w600)
                  ),
                  leading: Icon(Icons.delete, color: Colors.cyan[700]),
                  onTap: delete,
                ),
              ],
            ),
          ),

        );
      }
    );
  }

  void changeCaseTo(int newCase) {
    Navigator.of(context).pop();

    showLoading(
      context: context,
      title: "UPDATING TODO CASE...",
      waitFor: () async {
        await Firestore.updateTodoCase(
          teamId: teamId,
          todoId: todoModel.id,
          newCase: newCase
        );

        await dashboardCubit.getAllTodos();
      }
    );
  }

  void delete() {
    Navigator.of(context).pop();

    showLoading(
      context: context,
      title: "DELETING TODO...",
      waitFor: () async {
        await Firestore.deleteTodo(teamId: teamId, todoId: todoModel.id);
        await dashboardCubit.getAllTodos();
      }
    );
  }

  void edit() {
    Navigator.of(context).pop();

    showDialog(
      context: context,
      builder: (context) {
        return InputDialog(
          title: "UPDATE TODO",
          hint: "Enter new TODO",
          onConfirm: (String todo) async {
            String content = todo.trim();
            if (content.isEmpty) {
              Fluttertoast.showToast(msg: "No TODO entered");
              return false;
            }
            await Firestore.updateTodoContent(
              teamId: teamId,
              todoId: todoModel.id,
              newContent: content
            );
            await dashboardCubit.getAllTodos();
            return true;
          },
        );
      }
    );
  }
}
