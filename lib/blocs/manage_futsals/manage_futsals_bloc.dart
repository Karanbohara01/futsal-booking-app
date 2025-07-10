import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsal_frontend/blocs/manage_futsals/manage_futsals_event.dart';
import 'package:futsal_frontend/blocs/manage_futsals/manage_futsals_state.dart';
import 'package:futsal_frontend/data/services/api_service.dart';

class ManageFutsalsBloc extends Bloc<ManageFutsalsEvent, ManageFutsalsState> {
  final ApiService apiService;

  ManageFutsalsBloc({required this.apiService})
      : super(ManageFutsalsInitial()) {
    on<FetchOwnerFutsals>((event, emit) async {
      emit(ManageFutsalsLoading());
      try {
        final futsals = await apiService.getOwnerFutsals();
        emit(ManageFutsalsLoaded(futsals));
      } catch (e) {
        emit(ManageFutsalsError(e.toString()));
      }
    });
    on<AddFutsalButtonPressed>((event, emit) async {
      emit(
          ManageFutsalsLoading()); // You can create a more specific state if needed
      try {
        await apiService.createFutsal(
          name: event.name,
          address: event.address,
          pricePerHour: event.pricePerHour,
        );
        // After successfully creating, fetch the updated list
        final futsals = await apiService.getOwnerFutsals();
        emit(ManageFutsalsLoaded(futsals));
      } catch (e) {
        emit(ManageFutsalsError(e.toString()));
      }
    });
    on<DeleteFutsalButtonPressed>((event, emit) async {
      try {
        await apiService.deleteFutsal(event.futsalId);
        // Dispatch another event to refresh the list
        add(FetchOwnerFutsals());
      } catch (e) {
        // Optionally, emit an error state to show a SnackBar
        emit(ManageFutsalsError(e.toString()));
      }
    });
    on<UpdateFutsalButtonPressed>((event, emit) async {
      try {
        await apiService.updateFutsal(event.futsalId, {
          'name': event.name,
          'address': event.address,
          'price_per_hour': event.pricePerHour,
        });
        // Dispatch an event to refresh the list
        add(FetchOwnerFutsals());
      } catch (e) {
        emit(ManageFutsalsError(e.toString()));
      }
    });
  }
}
