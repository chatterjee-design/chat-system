import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'shared_items_event.dart';
part 'shared_items_state.dart';

class SharedItemsBloc extends Bloc<SharedItemsEvent, SharedItemsState> {
  SharedItemsBloc() : super(SharedItemsInitial()) {
    on<SharedItemsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
