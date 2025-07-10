import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsal_frontend/blocs/futsal/futsal_event.dart';
import 'package:futsal_frontend/blocs/futsal/futsal_state.dart';
import 'package:futsal_frontend/data/services/api_service.dart';

class FutsalBloc extends Bloc<FutsalEvent, FutsalState> {
  final ApiService apiService;

  FutsalBloc({required this.apiService}) : super(FutsalInitial()) {
    on<FetchFutsals>((event, emit) async {
      emit(FutsalLoading());
      try {
        final futsals = await apiService.getFutsals();
        emit(FutsalLoaded(futsals: futsals));
      } catch (e) {
        emit(FutsalError(message: e.toString()));
      }
    });
  }
}
