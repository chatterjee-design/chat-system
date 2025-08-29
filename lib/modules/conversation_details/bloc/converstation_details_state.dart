part of 'converstation_details_bloc.dart';

sealed class ConverstationDetailsState extends Equatable {
  const ConverstationDetailsState();
  
  @override
  List<Object> get props => [];
}

final class ConverstationDetailsInitial extends ConverstationDetailsState {}
