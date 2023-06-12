
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_finder/models/team_card_model.dart';
import 'package:team_finder/models/todo_model.dart';
import 'package:team_finder/screens/dashboard/dashboard_cubit.dart';
import 'package:team_finder/screens/dashboard/todo_card.dart';
import 'package:team_finder/shared_widgets/info_box.dart';

class Dashboard extends StatelessWidget {
  final TeamCardModel teamModel;
  const Dashboard({Key? key, required this.teamModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    DashboardCubit cubit = BlocProvider.of<DashboardCubit>(context);
    cubit.setInitial(teamModel);

    return Scaffold(
      backgroundColor: Colors.white,

      body: RefreshIndicator(
        backgroundColor: Colors.black,
        onRefresh: () async => await cubit.getAllTodos(),
        child: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (BuildContext context, DashboardState state) {
            if (state.isLoading) {
              return Padding(
                padding: EdgeInsets.only(bottom: height / 2),
                child: const Center(child: CircularProgressIndicator()),
              );
            }

            return ListView(
              physics: const BouncingScrollPhysics(),

              children: [
                todoList(title: "TODO", todos: state.todos),
                todoList(title: "DOING", todos: state.doing, color: Colors.green[900]),
                todoList(title: "DONE", todos: state.done, color: Colors.red[900]),

                placeHolder(state)
              ],
            );
          }
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => cubit.addTodo(context),
        backgroundColor: Colors.cyan[700],
        tooltip: "Add TODO",
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget todoList({required String title, required List<TodoModel> todos, Color? color}) {
    if (todos.isEmpty) return const SizedBox();

    return InfoBox(
      title: title,
      childPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      margin: const EdgeInsets.all(10),
      headerColor: color,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            for (TodoModel todo in todos)
              TodoCard(todoModel: todo, teamId: teamModel.id)
          ],
        ),
      )
    );
  }

  Widget placeHolder(DashboardState state) {
    bool notEmpty = state.todos.length + state.doing.length + state.done.length != 0;
    if (notEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Image.asset(
            "assets/images/not_found.gif",
            fit: BoxFit.cover
          ),

          const SizedBox(height: 20),

          const Text(
            "No TODOs yet",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22
            ),
          )
        ],
      ),
    );
  }
}


