
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_finder/models/team_card_model.dart';
import 'package:team_finder/screens/search_for_teams/team_card.dart';
import 'package:team_finder/screens/search_for_teams/teams_search_cubit.dart';
import 'package:team_finder/shared/user_data.dart';
import 'package:team_finder/shared_widgets/edited_text_field.dart';


class TeamsSearch extends StatelessWidget {
  const TeamsSearch({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    TeamsSearchCubit cubit = BlocProvider.of<TeamsSearchCubit>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        toolbarHeight: 110,
        elevation: 10,
        shadowColor: Colors.black,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        titleSpacing: 15,
        title: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: EditedTextField(
                    controller: cubit.searchController,
                    hint: "Search",
                    prefix: Icon(Icons.search,  color: Colors.cyan[700]),
                    minHeight: 50,
                    maxHeight: 50,
                    margin: const EdgeInsets.only(bottom: 10),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10)
                    ),
                  )
                ),

                InkWell(
                  onTap: () async => await cubit.getTeams(),
                  child: Container(
                    width: 60,
                    height: 50,
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.cyan[700],
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10)
                      )
                    ),

                    child: const Icon(Icons.search, color: Colors.white, size: 30),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                const SizedBox(width: 15),

                Container(
                  height: 35,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.cyan[700],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10)
                    )
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Filer Category",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ),

                Expanded(
                  child: Container(
                    height: 35,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10)
                      ),
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                      color: Colors.grey[700]
                    ),

                    child: BlocBuilder<TeamsSearchCubit, TeamsSearchState>(
                      builder: (context, state) => DropdownButton(
                        value: state.selectedCategory,
                        dropdownColor: Colors.grey[800],

                        hint: Text(
                          "Choose Team Category",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[400]
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white
                        ),
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down, size: 25, color: Colors.white),
                        onChanged: (String? newValue) => cubit.changeCategory(newValue),

                        items: ["All", ...categories].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 15),
              ],
            )
          ],
        )
      ),

      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: BlocBuilder<TeamsSearchCubit, TeamsSearchState>(
          builder: (context, state) {
            List<TeamCardModel> teamsCard = state.teamsCard ?? [];

            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (teamsCard.isEmpty) return placeHolder();

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: teamsCard.length,
              itemBuilder: (BuildContext context, int index) {
                return TeamCard(
                  width: width - 20,
                  teamCard: teamsCard[index],
                  cubit: cubit
                );
              },
            );
          }
        ),
      ),
    );
  }

  SingleChildScrollView placeHolder() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Image.asset(
              "assets/images/not_found.gif",
              fit: BoxFit.cover
            ),

            const SizedBox(height: 20),

            const Text(
              "No results found",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22
              ),
            ),
          ],
        ),
      ),
    );
  }
}

