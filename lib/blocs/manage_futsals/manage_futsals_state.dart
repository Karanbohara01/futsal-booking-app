import 'package:equatable/equatable.dart';
import 'package:futsal_frontend/data/models/futsal_model.dart';

abstract class ManageFutsalsState extends Equatable {
  const ManageFutsalsState();
  @override
  List<Object> get props => [];
}

class ManageFutsalsInitial extends ManageFutsalsState {}

class ManageFutsalsLoading extends ManageFutsalsState {}

class ManageFutsalsLoaded extends ManageFutsalsState {
  final List<Futsal> futsals;
  const ManageFutsalsLoaded(this.futsals);
  @override
  List<Object> get props => [futsals];
}

class ManageFutsalsError extends ManageFutsalsState {
  final String message;
  const ManageFutsalsError(this.message);
  @override
  List<Object> get props => [message];
}
