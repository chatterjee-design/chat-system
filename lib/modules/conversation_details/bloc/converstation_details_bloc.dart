import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'converstation_details_event.dart';
part 'converstation_details_state.dart';

class ConverstationDetailsBloc extends Bloc<ConverstationDetailsEvent, ConverstationDetailsState> {
  ConverstationDetailsBloc() : super(ConverstationDetailsInitial()) {
    on<ConverstationDetailsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
