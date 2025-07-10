import 'package:equatable/equatable.dart';

abstract class FutsalEvent extends Equatable {
  const FutsalEvent();

  @override
  List<Object> get props => [];
}

class FetchFutsals extends FutsalEvent {}
