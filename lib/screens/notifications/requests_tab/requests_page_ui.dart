
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_finder/screens/notifications/requests_tab/request_card.dart';
import 'package:team_finder/screens/notifications/requests_tab/requests_cubit.dart';

class RequestsPage extends StatelessWidget {
  const RequestsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RequestCubit cubit = BlocProvider.of<RequestCubit>(context);
    double height = MediaQuery.of(context).size.height;

    return BlocBuilder<RequestCubit, RequestsState>(
      builder: (BuildContext context, RequestsState state) {
        if (state.isLoading) {
          return Padding(
            padding: EdgeInsets.only(bottom: height / 2),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state.requestsModel.isEmpty) return placeHolder();

        return ListView.builder(
          itemCount: state.requestsModel.length,
          itemBuilder: (context, index) {
            return RequestCard(
              joinRequest: state.requestsModel[index],
              requestCubit: cubit
            );
          },
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
            "No join requests",
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



