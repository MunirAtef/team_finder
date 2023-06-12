
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_finder/shared/user_data.dart';

class AcceptanceState {
  List<String> teamsId;
  bool isLoading;

  AcceptanceState({
    this.teamsId = const [],
    this.isLoading = false
  });
}


class AcceptanceCubit extends Cubit<AcceptanceState> {
  AcceptanceCubit(): super(AcceptanceState(teamsId: UserData.acceptance));

}
