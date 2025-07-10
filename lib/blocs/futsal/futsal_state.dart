import 'package:equatable/equatable.dart';
import 'package:futsal_frontend/data/models/futsal_model.dart';

abstract class FutsalState extends Equatable {
  const FutsalState();

  @override
  List<Object> get props => [];
}

class FutsalInitial extends FutsalState {}

class FutsalLoading extends FutsalState {}

class FutsalLoaded extends FutsalState {
  final List<Futsal> futsals;

  const FutsalLoaded({required this.futsals});

  @override
  List<Object> get props => [futsals];
}

class FutsalError extends FutsalState {
  final String message;

  const FutsalError({required this.message});

  @override
  List<Object> get props => [message];
}
