import 'package:equatable/equatable.dart';

abstract class ManageFutsalsEvent extends Equatable {
  const ManageFutsalsEvent();
  @override
  List<Object> get props => [];
}

class FetchOwnerFutsals extends ManageFutsalsEvent {}

class AddFutsalButtonPressed extends ManageFutsalsEvent {
  final String name;
  final String address;
  final int pricePerHour;

  const AddFutsalButtonPressed({
    required this.name,
    required this.address,
    required this.pricePerHour,
  });

  @override
  List<Object> get props => [name, address, pricePerHour];
}

class DeleteFutsalButtonPressed extends ManageFutsalsEvent {
  final String futsalId;
  const DeleteFutsalButtonPressed(this.futsalId);

  @override
  List<Object> get props => [futsalId];
}

class UpdateFutsalButtonPressed extends ManageFutsalsEvent {
  final String futsalId;
  final String name;
  final String address;
  final int pricePerHour;

  const UpdateFutsalButtonPressed({
    required this.futsalId,
    required this.name,
    required this.address,
    required this.pricePerHour,
  });

  @override
  List<Object> get props => [futsalId, name, address, pricePerHour];
}
