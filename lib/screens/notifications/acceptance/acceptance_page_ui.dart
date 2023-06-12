
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_finder/screens/notifications/acceptance/acceptance_card.dart';
import 'package:team_finder/screens/notifications/acceptance/acceptance_cubit.dart';

class Acceptance extends StatelessWidget {
  const Acceptance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AcceptanceCubit cubit = BlocProvider.of<AcceptanceCubit>(context);
    double height = MediaQuery.of(context).size.height;

    return BlocBuilder<AcceptanceCubit, AcceptanceState>(
      builder: (BuildContext context, AcceptanceState state) {
        if (state.isLoading) {
          return Padding(
            padding: EdgeInsets.only(bottom: height / 2),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state.teamsId.isEmpty) return placeHolder();

        return ListView.builder(
          itemCount: state.teamsId.length,
          itemBuilder: (BuildContext context, int index) {
            return AcceptanceCard(
              teamId: state.teamsId[index],
              acceptanceCubit: cubit
            );
          }
        );
      },
    );
  }


  Widget placeHolder() {
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
            "No acceptance notifications",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22
            ),
          ),
        ],
      ),
    );
  }
}


